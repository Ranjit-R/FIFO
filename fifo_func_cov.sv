class fifo_cov extends uvm_component;
  `uvm_component_utils(fifo_cov)

  // Two analysis exports — one for write, one for read
  uvm_tlm_analysis_fifo #(fifo_write_seq_item) write_fifo;
  uvm_tlm_analysis_fifo #(fifo_read_seq_item) read_fifo;


  fifo_write_seq_item wr_item;
  fifo_read_seq_item  rd_item;

   real wr_coverage, rd_coverage;

  // --------------------------
  // Covergroups
  // --------------------------

  // Write coverage
 covergroup write_cg;
    // Cover write data ranges
    write_data: coverpoint wr_item.wdata {
      bins data_low = {[0:127]};
      bins data_high  = {[128:255]};
    }

    // Cover write full flag
    wfull: coverpoint wr_item.wfull {
      bins full_flag[] = {0, 1};
    }

    // Cover write increment
    winc: coverpoint wr_item.winc {
      bins winc[] = {0, 1};
    }
  endgroup

  covergroup read_cg;
    // Cover read data ranges
    read_data: coverpoint rd_item.rdata {
      bins data_low = {[0:127]};
      bins data_high  = {[128:255]};
    }

    // Cover read empty flag
    rempty: coverpoint rd_item.rempty {
      bins empty_flag[] = {0, 1};
    }

    // Cover read increment
    rinc: coverpoint rd_item.rinc {
      bins rinc[] = {0, 1};
    }
  endgroup

  // --------------------------
  // Constructor
  // --------------------------
  function new(string name = "fifo_subscriber", uvm_component parent = null);
    super.new(name, parent);
    write_fifo = new("write_fifo", this);
    read_fifo  = new("read_fifo", this);
    write_cg = new();
    read_cg  = new();
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
      forever begin
        write_fifo.get(wr_item);
        write_cg.sample();
        read_fifo.get(rd_item);
        read_cg.sample();
      end
  endtask
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    wr_coverage = write_cg.get_coverage();
    rd_coverage = read_cg.get_coverage();
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("[Write] Coverage : %0.2f%%", wr_coverage), UVM_MEDIUM);
    `uvm_info(get_type_name(), $sformatf("[Read] Coverage : %0.2f%%", rd_coverage), UVM_MEDIUM);
  endfunction 
endclass
