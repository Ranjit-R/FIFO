
class fifo_write_seq_item extends uvm_sequence_item;

    rand logic [`DATA_WIDTH-1:0] wdata;
    rand logic winc;
    bit wfull;
    // logic [`ADDR_WIDTH:0] wptr;

    

    `uvm_object_utils_begin(fifo_write_seq_item)
        `uvm_field_int(wdata, UVM_ALL_ON | UVM_DEC);
        `uvm_field_int(winc, UVM_ALL_ON | UVM_DEC);
        `uvm_field_int(wfull, UVM_ALL_ON | UVM_DEC);
        // `uvm_field_int(wptr, UVM_ALL_ON | UVM_DEC);
    `uvm_object_utils_end;

    function new(string name ="fifo_write_seq_item");
        super.new(name);
    endfunction //new()
   
constraint c{
	wdata inside {[0:256]};
} 
endclass //fifo_write_seq_item extends uvm_seq_item


class fifo_read_seq_item extends uvm_sequence_item;

    logic [`DATA_WIDTH-1:0] rdata;
    rand logic rinc;
    logic rempty;
    // logic [`ADDR_WIDTH:0] rptr;

    `uvm_object_utils_begin(fifo_read_seq_item)
        `uvm_field_int(rdata, UVM_ALL_ON | UVM_DEC);
        `uvm_field_int(rinc, UVM_ALL_ON | UVM_DEC);
        `uvm_field_int(rempty, UVM_ALL_ON | UVM_DEC);
        // `uvm_field_int(rptr, UVM_ALL_ON | UVM_DEC);
    `uvm_object_utils_end;

    function new(string name ="fifo_read_seq_item");
        super.new(name);
    endfunction //new()

endclass //fifo_read_seq_item extends uvm_seq_item
