class fifo_write_test extends uvm_test;
  `uvm_component_utils(fifo_write_test)
  fifo_environment env;
  fifo_write_sequence seq;

  function new(string name = "fifo_write_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction 

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_environment::type_id::create("env", this);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq = fifo_write_sequence::type_id::create("seq");
    seq.start(env.write_agent.sequencer);
    phase.drop_objection(this);
  endtask
endclass


class fifo_read_test extends uvm_test;
  `uvm_component_utils(fifo_read_test)
  fifo_environment env;
  fifo_read_sequence seq;

  function new(string name = "fifo_read_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction 

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_environment::type_id::create("env", this);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq = fifo_read_sequence::type_id::create("seq");
    seq.start(env.read_agent.sequencer);
    phase.drop_objection(this);
  endtask
endclass


class fifo_write_then_read_test extends uvm_test;
  `uvm_component_utils(fifo_write_then_read_test)
  fifo_environment env;
  fifo_write_sequence write_seq;
  fifo_read_sequence read_seq;

  function new(string name = "fifo_write_then_read_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction 

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_environment::type_id::create("env", this);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    write_seq = fifo_write_sequence::type_id::create("write_seq");
    read_seq = fifo_read_sequence::type_id::create("read_seq");

    fork
      begin
            write_seq.start( env.write_agent.sequencer );
            #60;
            read_seq.start( env.read_agent.sequencer );
      end
    join
    phase.drop_objection(this);
  endtask
  endclass



  class fifo_write_read_test extends uvm_test;
  `uvm_component_utils(fifo_write_read_test)
  fifo_environment env;
  fifo_write_sequence write_seq;
  fifo_read_sequence read_seq;

  function new(string name = "fifo_write_read_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction 

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_environment::type_id::create("env", this);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    write_seq = fifo_write_sequence::type_id::create("write_seq");
    read_seq = fifo_read_sequence::type_id::create("read_seq");

    fork
     
            write_seq.start( env.write_agent.sequencer );
            read_seq.start( env.read_agent.sequencer );
    join
    phase.drop_objection(this);
  endtask
  endclass

  // class fifo_virtual_sequence_test extends uvm_test;
  // `uvm_component_utils(fifo_virtual_sequence_test)
  // fifo_environment env;
  // fifo_virtual_sequence virtual_seq;

  // function new(string name = "fifo_virtual_sequence_test",uvm_component parent=null);
  //     super.new(name,parent);
  // endfunction

  // virtual function void build_phase(uvm_phase phase);
  //     super.build_phase(phase);
  //     env = fifo_environment::type_id::create("env", this);
  //     virtual_seq = fifo_virtual_sequence::type_id::create("virtual_seq", this);
  // endfunction

  // virtual function void end_of_elaboration_phase(uvm_phase phase);
  //     super.end_of_elaboration_phase(phase);
  //     uvm_top.print_topology();
  // endfunction

  // virtual task run_phase(uvm_phase phase);
  //     super.run_phase(phase);
  //     phase.raise_objection(this);
  //     virtual_seq.start(env.virtual_seqr);
  //     phase.drop_objection(this);
  // endtask
  // endclass
