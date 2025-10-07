`include "uvm_macros.svh"

// Declare custom analysis implementation macros
`uvm_analysis_imp_decl(_write)
`uvm_analysis_imp_decl(_read)

class fifo_cov extends uvm_component;
  `uvm_component_utils(fifo_cov)
  
  // Analysis imports for TLM connection
  uvm_analysis_imp_write #(fifo_write_seq_item, fifo_cov) write_export;
  uvm_analysis_imp_read  #(fifo_read_seq_item, fifo_cov)  read_export;
  
  // Local variables to store sampled data
  bit winc;
  bit wfull;
  bit [7:0] wdata;
  
  bit rinc;
  bit rempty;
  bit [7:0] rdata;
  
  // Covergroups with sampling arguments
  covergroup write_cg;
    option.per_instance = 1;
    cp_winc: coverpoint winc;
    cp_wfull: coverpoint wfull;
    cp_wdata: coverpoint wdata;
    cross_winc_wfull: cross winc, wfull;
    cross_winc_wdata: cross winc, wdata;
  endgroup
  
  covergroup read_cg;
    option.per_instance = 1;
    cp_rinc: coverpoint rinc;
    cp_rempty: coverpoint rempty;
    cp_rdata: coverpoint rdata;
    cross_rinc_rempty: cross rinc, rempty;
    cross_rinc_rdata: cross rinc, rdata;
  endgroup
  
  function new(string name="fifo_cov", uvm_component parent=null);
    super.new(name, parent);
    write_export = new("write_export", this);
    read_export  = new("read_export", this);
    write_cg = new();
    read_cg = new();
  endfunction
  
  // Write method for write transactions
  virtual function void write_write(fifo_write_seq_item t);
    winc = t.winc;
    wfull = t.wfull;
    wdata = t.wdata;
    write_cg.sample();
    `uvm_info(get_type_name(), $sformatf("Write Coverage Sampled: winc=%0b, wfull=%0b, wdata=0x%0h", 
              winc, wfull, wdata), UVM_HIGH);
  endfunction
  
  // Write method for read transactions
  virtual function void write_read(fifo_read_seq_item t);
    rinc = t.rinc;
    rempty = t.rempty;
    rdata = t.rdata;
    read_cg.sample();
    `uvm_info(get_type_name(), $sformatf("Read Coverage Sampled: rinc=%0b, rempty=%0b, rdata=0x%0h", 
              rinc, rempty, rdata), UVM_HIGH);
  endfunction
  
endclass
