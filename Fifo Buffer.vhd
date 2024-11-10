library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FIFO is
    generic (
        DEPTH : natural := 32; -- Dubina reda
        WIDTH : natural := 32  -- ?irina reda
    );
    port (
        clk        : in std_logic;
        rst        : in std_logic;
        wr_enable  : in std_logic;
        rd_enable  : in std_logic;
        data_in    : in std_logic_vector(WIDTH-1 downto 0);
        data_out   : out std_logic_vector(WIDTH-1 downto 0);
        full       : out std_logic;
        empty      : out std_logic
    );
end entity;

architecture buff of FIFO is
    type memory_array is array (0 to DEPTH-1) of std_logic_vector(WIDTH-1 downto 0);
    signal memory      : memory_array;
    signal wr_pointer  : integer range 0 to DEPTH-1 := 0;
    signal rd_pointer  : integer range 0 to DEPTH-1 := 0;
    signal count       : integer range 0 to DEPTH := 0;
begin

    process(clk, rst)
    begin
        if rst = '1' then
            wr_pointer <= 0;
            rd_pointer <= 0;
            count <= 0;
            data_out <= (others => '0');
        elsif rising_edge(clk) then
            -- Handle write operation
            if wr_enable = '1' and count < DEPTH then
                memory(wr_pointer) <= data_in;
                wr_pointer <= (wr_pointer + 1) mod DEPTH;
                count <= count + 1;
            end if;
            -- Handle read operation
            if rd_enable = '1' and count > 0 then
                data_out <= memory(rd_pointer);
                rd_pointer <= (rd_pointer + 1) mod DEPTH;
                count <= count - 1;
            end if;
        end if;
    end process;

    -- Output flags
    full <= '1' when count = DEPTH else '0';
    empty <= '1' when count = 0 else '0';

end buff;
