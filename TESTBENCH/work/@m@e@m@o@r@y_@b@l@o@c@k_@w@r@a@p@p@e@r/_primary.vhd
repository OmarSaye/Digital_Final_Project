library verilog;
use verilog.vl_types.all;
entity MEMORY_BLOCK_WRAPPER is
    port(
        MOSI            : in     vl_logic;
        MISO            : out    vl_logic;
        SS_n            : in     vl_logic;
        clk             : in     vl_logic;
        rst_n           : in     vl_logic
    );
end MEMORY_BLOCK_WRAPPER;
