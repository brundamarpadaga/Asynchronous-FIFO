module async_fifo_tb;

  parameter FIFO_WIDTH = 8;
  parameter ADDR_WIDTH = 9;
  parameter BUR_LEN = 450;
  localparam DEPTH = 1<<ADDR_WIDTH;

  logic [FIFO_WIDTH-1:0] rdata;
  logic wfull;
  logic rempty;
  logic [FIFO_WIDTH-1:0] wdata;
  logic wclk, wrst_n;
  logic winc = 1'b0;
  logic rclk, rrst_n;
  logic rinc = 1'b0;

  logic [FIFO_WIDTH-1:0] read_return_data, data_to_write;

  // Instantiate the FIFO
  async_fifo #(FIFO_WIDTH, ADDR_WIDTH) dut_inst (.*);

  //clock generation blocks
  initial begin
    wclk = 1'b0;
    rclk = 1'b0;

    fork
      forever #1ns wclk = ~wclk;  //write frequency is 500MHz
      forever #1ns rclk = ~rclk;  //read frequency is 500MHz
    join
  end

  initial begin
    
    ApplyReset();
    assert(wfull === 1'b0) else $error("Write pointer check failed on reset");
    assert(rempty === 1'b1) else $error("Write pointer check failed on reset");

    for (int i=1; i<=DEPTH; i++) begin    //filling the FIFO
      @(negedge wclk); ApplyWrite(2*i);
      assert(wfull === 1'b0) else $error("Full signal asserted before FIFO is full.!");  
    end

    @(negedge wclk); 
    assert(wfull === 1'b1) else $error("Full not asserted after FIFO is full.!"); 

    #10ns;

    for (int i=1; i<DEPTH; i++) begin    //emptying the FIFO
      @(negedge rclk); ApplyRead(read_return_data);
      assert(rempty === 1'b0) else $error("Empty signal asserted before FIFO is cleared.!");
    end

    @(negedge rclk); ApplyRead(read_return_data);

    @(negedge rclk); 
    assert(rempty === 1'b1) else $error("Empty not asserted after FIFO is cleared.!"); 
    
    ApplyReset();

    //random test cases while applying concurrent reads and writes
    fork
      begin
        for (int i=1; i<=BUR_LEN; i++) begin    //filling the FIFO
          data_to_write = $random();
          @(negedge wclk); ApplyWrite(data_to_write);  
        end
      end

      begin
        repeat(8) @(negedge rclk)     //waiting for empty to clear ebfore reading
        for (int i=1; i<BUR_LEN; i++) begin    //emptying the FIFO
          @(negedge rclk); ApplyRead(read_return_data);
        end
      end
    join


    #5ns;
    $finish;

  end

task ApplyWrite(input logic [7:0] write_data);
  if (wfull == 0) begin
    winc = 1;
    wdata = write_data;
    @(posedge wclk);
    winc = 0;
    wdata = 'x;
  end
endtask

task ApplyRead(output logic [7:0] read_data);
  if (rempty == 0) begin
    rinc = 1;
    @(posedge rclk);
    rinc = 0;
    read_data = rdata;
    repeat (4) @(posedge rclk); // 4 idle cycles followed by a read
  end
endtask 

task ApplyReset();
  #2;
  rrst_n = 0;
  wrst_n = 0;

  #2;
  rrst_n = 1;
  wrst_n = 1;
endtask

endmodule