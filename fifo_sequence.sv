class fifo_write_sequence extends uvm_sequence #(fifo_write_seq_item);
    `uvm_object_utils(fifo_write_sequence)
    int no_of_trans;
    int count = 0;

    function new(string name = "fifo_write_sequence");
        super.new(name);
    endfunction //new()

    virtual task body();
        fifo_write_seq_item item;

        if (!$value$plusargs("no_of_trans=%d", no_of_trans)) begin
            no_of_trans = 10; // default value 
        end

        repeat(no_of_trans)begin
            item = fifo_write_seq_item::type_id::create("item");
            start_item(item);
                if(count < 16)
                item.randomize() with { winc == 1'b1;wdata == count;};
                else
                item.randomize() with { winc == 1'b0;wdata == count;};
            finish_item(item);
            `uvm_info(get_type_name(), $sformatf("Write Sequence Item: wdata = %0h, winc = %0b, wfull = %0b", item.wdata, item.winc, item.wfull), UVM_MEDIUM)
            count ++;
            // if(count == 15)
            //     count = 0;
        end

    endtask // body

endclass //fifo_write_sequence extends uvm_sequence


class fifo_read_sequence extends uvm_sequence #(fifo_read_seq_item);
    `uvm_object_utils(fifo_read_sequence)
    int no_of_trans;

    function new(string name = "fifo_read_sequence");
        super.new(name);
    endfunction //new()

    virtual task body();
        fifo_read_seq_item item;

        

        repeat(`no_trans) begin
            item = fifo_read_seq_item::type_id::create("item");
            start_item(item);
            item.randomize() with { rinc == 1'b1; };
            finish_item(item);
            `uvm_info(get_type_name(), $sformatf("Read Sequence Item: rdata = %0h, rinc = %0b, rempty = %0b", item.rdata, item.rinc, item.rempty), UVM_MEDIUM);
        end
    endtask // body
endclass //fifo_read_seq extends superClass

// class fifo_virtual_sequence extends uvm_sequence #(uvm_sequence_item);
    
//     fifo_write_sequence write_seq;
//     fifo_read_sequence read_seq;

//     // fifo_write_sequencer write_seqr;
//     // fifo_read_sequencer read_seqr;

//     `uvm_object_utils(fifo_virtual_sequence)
//     `uvm_declare_p_sequencer(fifo_virtual_sequencer)


//     function new(string name = "fifo_virtual_sequence");
//         super.new(name);
//     endfunction //new()


//     virtual task body();
//         write_seq = fifo_write_sequence::type_id::create("write_seq");
//         read_seq = fifo_read_sequence::type_id::create("read_seq");

//         fork
           
//             write_seq.start( p_sequencer );
//             read_seq.start( p_sequencer );
            
//         join
//     endtask //body
//     endclass
