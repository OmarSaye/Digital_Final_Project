library verilog;
use verilog.vl_types.all;
entity project_SPI_slave is
    generic(
        IDLE            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        CHK_CMD         : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        READ_ADD        : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        READ_DATA       : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        WRITE           : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        MOSI            : in     vl_logic;
        SS_n            : in     vl_logic;
        tx_valid        : in     vl_logic;
        tx_data         : in     vl_logic_vector(7 downto 0);
        MISO            : out    vl_logic;
        rx_valid        : out    vl_logic;
        rx_data         : out    vl_logic_vector(9 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of CHK_CMD : constant is 1;
    attribute mti_svvh_generic_type of READ_ADD : constant is 1;
    attribute mti_svvh_generic_type of READ_DATA : constant is 1;
    attribute mti_svvh_generic_type of WRITE : constant is 1;
end project_SPI_slave;
