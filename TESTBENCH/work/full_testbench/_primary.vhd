library verilog;
use verilog.vl_types.all;
entity full_testbench is
    generic(
        clk_cycle       : integer := 30
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of clk_cycle : constant is 1;
end full_testbench;
