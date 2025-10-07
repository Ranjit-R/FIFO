class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)

  localparam int FIFO_DEPTH = 16;

  uvm_tlm_analysis_fifo #(fifo_write_seq_item) write_fifo;
  uvm_tlm_analysis_fifo #(fifo_read_seq_item)  read_fifo;

 
  bit [`DATA_WIDTH-1:0] ref_queue[$];

 
  int write_count, read_count;
  int successful_writes, successful_reads;
  int match_count, mismatch_count;
  int write_when_full, read_when_empty;
  int model_full_violation;

  function new(string name = "fifo_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    write_fifo = new("write_fifo", this);
    read_fifo  = new("read_fifo", this);
  endfunction

  task run_phase(uvm_phase phase);
    fork
      monitor_writes();
      monitor_reads();
    join_none
  endtask

  // ---------------------- WRITE HANDLER ----------------------
  task monitor_writes();
    fifo_write_seq_item wr;
    forever begin
      write_fifo.get(wr);
      write_count++;

      if (wr.winc) begin

        if (ref_queue.size() >= FIFO_DEPTH) begin
          model_full_violation++;
          `uvm_warning("SCOREBOARD", $sformatf(
            "MODEL FULL! Depth=%0d. Attempted to push data=0x%0h", 
            ref_queue.size(), wr.wdata))
        end

        if (!wr.wfull) begin
          if (ref_queue.size() < FIFO_DEPTH) begin
            ref_queue.push_back(wr.wdata);
            successful_writes++;
            `uvm_info("SCOREBOARD", $sformatf(
              "WRITE: data=0x%0h | Queue Depth=%0d",
              wr.wdata, ref_queue.size()), UVM_MEDIUM)
          end
          else begin
            `uvm_error("SCOREBOARD", "DUT missed FULL condition (should assert wfull)")
          end
        end
        else begin
          write_when_full++;
          if (ref_queue.size() < FIFO_DEPTH)
            `uvm_error("SCOREBOARD", "DUT asserted wfull early (FIFO not full)")
          else
            `uvm_info("SCOREBOARD", "WRITE blocked since FIFO FULL", UVM_LOW)
        end
      end
    end
  endtask

  // ---------------------- READ HANDLER ----------------------
  task monitor_reads();
    fifo_read_seq_item rd;
    bit [`DATA_WIDTH-1:0] expected_data;

    forever begin
      read_fifo.get(rd);
      read_count++;

      if (rd.rinc && !rd.rempty) begin
        if (ref_queue.size() == 0) begin
          `uvm_error("SCOREBOARD", "Underflow: FIFO EMPTY but read attempted")
        end
        else begin
          expected_data = ref_queue.pop_front();
          successful_reads++;

          if (expected_data === rd.rdata) begin
            match_count++;
            `uvm_info("SCOREBOARD", $sformatf(
              "MATCH Exp=0x%0h, Got=0x%0h | Remaining=%0d",
              expected_data, rd.rdata, ref_queue.size()), UVM_MEDIUM)
          end
          else begin
            mismatch_count++;
            `uvm_error("SCOREBOARD", $sformatf(
              "MISMATCH Exp=0x%0h, Got=0x%0h", expected_data, rd.rdata))
          end
        end
      end
      else if (rd.rinc && rd.rempty) begin
        read_when_empty++;
        `uvm_warning("SCOREBOARD", "Attempted READ when FIFO EMPTY")
      end
    end
  endtask

  // ---------------------- FINAL REPORT ----------------------
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    `uvm_info("SCOREBOARD", "========================================", UVM_LOW)
    `uvm_info("SCOREBOARD", "         FINAL SCOREBOARD REPORT        ", UVM_LOW)
    `uvm_info("SCOREBOARD", "========================================", UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total Writes        : %0d", write_count), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total Reads         : %0d", read_count), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Successful Writes   : %0d", successful_writes), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Successful Reads    : %0d", successful_reads), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Write When Full     : %0d", write_when_full), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Read When Empty     : %0d", read_when_empty), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Model Full Violations: %0d", model_full_violation), UVM_LOW)
    `uvm_info("SCOREBOARD", "----------------------------------------", UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Data Matches        : %0d", match_count), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Data Mismatches     : %0d", mismatch_count), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Remaining Queue Size: %0d", ref_queue.size()), UVM_LOW)
    `uvm_info("SCOREBOARD", "========================================", UVM_LOW)

    if (mismatch_count == 0 && model_full_violation == 0)
      `uvm_info("SCOREBOARD", "*** TEST PASSED  ***", UVM_LOW)
    else
      `uvm_error("SCOREBOARD", "*** TEST FAILED  ***")
  endfunction

endclass
