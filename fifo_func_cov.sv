`include "uvm_macros.svh"

// Declare analysis implementation macros
`uvm_analysis_imp_decl(_write)
`uvm_analysis_imp_decl(_read)

class fifo_cov extends uvm_component;
  `uvm_component_utils(fifo_cov)

  // Analysis exports for TLM connections
  uvm_analysis_imp_write #(fifo_write_seq_item, fifo_cov) write_export;
  uvm_analysis_imp_read  #(fifo_read_seq_item, fifo_cov)  read_export;

  // Local variables for coverage sampling
  bit winc, wfull;
  bit [7:0] wdata;

  bit rinc, rempty;
  bit [7:0] rdata;

  real wr_cov_report;
  real rd_cov_report;


//   covergroup write_cg;
//     option.per_instance = 1;
//     cp_winc  : coverpoint winc;
//     cp_wfull : coverpoint wfull;
//     cp_wdata : coverpoint wdata {
//       bins low  = {[0:63]};
//       bins high = {[64:255]};
//     }
    
    
// //     cross_winc_wfull : cross winc, wfull;
// //     cross_winc_wdata : cross winc, wdata;
//   endgroup
  
//   covergroup write_cg;
//     write_data: coverpoint wdata{
//       bins data_first = {[0:127]};
//       bins data_last = {[128:255]};
//     }
//     wfull: coverpoint wfull{
//       bins full_flag[] = {0,1};
//     }
//     winc: coverpoint winc{
//       bins winc[] = {0,1};
//     }
//   endgroup
  
//   covergroup read_cg;
//     read_data: coverpoint rdata{
//       bins data_first = {[0:127]};
//       bins data_last = {[128:255]};
//     }
//     rempty: coverpoint rempty{
//       bins empty_flag[] = {0,1};
//     }
//     rinc: coverpoint rinc{
//       bins rinc[] = {0,1};
//     }
//   endgroup
  
  covergroup write_cg;
//     w_rst: coverpoint wrst_n;
    w_inc: coverpoint winc;
    w_data: coverpoint wdata {
      bins w_low = {[0:63]};
      bins w_mid = {[64:127]};
      bins w_high = {[128:255]};
    }
    w_full: coverpoint wfull;
  endgroup
  covergroup read_cg;
//     r_rst: coverpoint rrst_n;
    r_inc: coverpoint rinc;
    r_data: coverpoint rdata {
      bins r_low = {[0:63]};
      bins r_mid = {[64:127]};
      bins r_high = {[128:255]};
    }
    r_empty: coverpoint rempty;
  endgroup

//   covergroup read_cg;
//     option.per_instance = 1;
//     cp_rinc  : coverpoint rinc;
//     cp_rempty: coverpoint rempty;
//     cp_rdata : coverpoint rdata {
//       bins low  = {[0:63]};
//       bins high = {[64:255]};
//     }
// //     cross_rinc_rempty : cross rinc, rempty;
// //     cross_rinc_rdata  : cross rinc, rdata;
//   endgroup


  function new(string name = "fifo_cov", uvm_component parent = null);
    super.new(name, parent);
    write_export = new("write_export", this);
    read_export  = new("read_export", this);
    write_cg = new();
    read_cg  = new();
  endfunction

  virtual function void write_write(fifo_write_seq_item t);
    winc  = t.winc;
    wfull = t.wfull;
    wdata = t.wdata;
    write_cg.sample();
    `uvm_info(get_type_name(),
      $sformatf("WRITE Sample: winc=%0b wfull=%0b wdata=0x%0h",
      winc, wfull, wdata), UVM_HIGH)
  endfunction

  virtual function void write_read(fifo_read_seq_item t);
    rinc   = t.rinc;
    rempty = t.rempty;
    rdata  = t.rdata;
    read_cg.sample();
    `uvm_info(get_type_name(),
      $sformatf("READ Sample: rinc=%0b rempty=%0b rdata=0x%0h",
      rinc, rempty, rdata), UVM_HIGH)
  endfunction


  virtual function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    wr_cov_report = write_cg.get_coverage();
   rd_cov_report = read_cg.get_coverage();
  endfunction

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_full_name(),
      $sformatf("[WRITE] Coverage = %0.2f%%", wr_cov_report), UVM_LOW)
    `uvm_info(get_full_name(),
              $sformatf("[READ]  Coverage = %0.2f%%\n\n", rd_cov_report), UVM_LOW)
  endfunction

endclass

