module fetch_tb;

    // Inputs
    reg clk;
    reg pc_src;
    reg [31:0] branch_target;

    // Outputs
    wire [31:0] pc;
    wire [31:0] instr;

    // Instantiate the fetch module
    fetch fetch_inst (
        .clk(clk),
        .pc_src(pc_src),
        .branch_target(branch_target),
        .pc(pc),
        .instr(instr)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Create a 10ns clock period
    end

    // Testbench procedure
    initial begin
        // Initialize inputs
        pc_src = 0;
        branch_target = 32'hAABBCCDD; // Example branch target
        
        // Allow some time for initialization
        #10;

        // Test case 1: Sequential fetch
        $display("Test Case 1: Sequential fetch");
        pc_src = 0;
        #10;
        $display("PC: %h, Instruction: %h", pc, instr);

        // Test case 2: Branch fetch
        $display("Test Case 2: Branch fetch");
        pc_src = 1;
        #10;
        $display("PC: %h, Instruction: %h", pc, instr);

        $finish;
    end

endmodule
