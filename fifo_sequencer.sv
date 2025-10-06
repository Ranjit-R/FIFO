
class fifo_write_sequencer extends uvm_sequencer #(fifo_write_seq_item);
  `uvm_component_utils(fifo_write_sequencer)

  function new(string name="fifo_write_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction

endclass


class fifo_read_sequencer extends uvm_sequencer #(fifo_read_seq_item);
    `uvm_component_utils(fifo_read_sequencer)

    function new(string name="fifo_read_sequencer", uvm_component parent=null);
        super.new(name, parent);
    endfunction

endclass //fifo_read_sequencer extends uvm_sequencer 

vi

// class fifo_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
//     `uvm_component_utils(fifo_virtual_sequencer)

//     fifo_write_sequencer write_seqr;
//     fifo_read_sequencer read_seqr;

//     function new(string name="fifo_virtual_sequencer", uvm_component parent=null);
//         super.new(name, parent);
//     endfunction

//     virtual function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         write_seqr = fifo_write_sequencer::type_id::create("write_seqr", this);
//         read_seqr = fifo_read_sequencer::type_id::create("read_seqr", this);
//     endfunction
//     endclass

