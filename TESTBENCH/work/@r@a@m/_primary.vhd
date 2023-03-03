library verilog;
use verilog.vl_types.all;
entity RAM is
    generic(
        MEM_DEPTH       : integer := 256;
        ADDR_SIZE       : integer := 8;
        WRITE_ADDRESS   : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        WRITE_DATA      : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        READ_ADDRESS    : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        READ_DATA       : vl_logic_vector(0 to 1) := (Hi1, Hi1)
    );
    port(
        din             : in     vl_logic_vector(9 downto 0);
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        rx_valid        : in     vl_logic;
        dout            : out    vl_logic_vector(7 downto 0);
        tx_valid        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MEM_DEPTH : constant is 1;
    attribute mti_svvh_generic_type of ADDR_SIZE : constant is 1;
    attribute mti_svvh_generic_type of WRITE_ADDRESS : constant is 1;
    attribute mti_svvh_generic_type of WRITE_DATA : constant is 1;
    attribute mti_svvh_generic_type of READ_ADDRESS : constant is 1;
    attribute mti_svvh_generic_type of READ_DATA : constant is 1;
end RAM;
