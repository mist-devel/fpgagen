-- Generic dual-port RAM implementation -
-- will hopefully work for both Altera and Xilinx parts

library ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY dpram_dclk IS
	GENERIC
	(
		addrbits : integer := 9;
		databits : integer := 7
	);
	PORT
	(
		rdaddress		: IN STD_LOGIC_VECTOR (addrbits-1 downto 0);
		wraddress		: IN STD_LOGIC_VECTOR (addrbits-1 downto 0);
		rdclock		: IN STD_LOGIC  := '1';
		wrclock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (databits-1 downto 0);
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (databits-1 downto 0)
	);
END dpram_dclk;

architecture arch of dpram_dclk is

type ram_type is array(natural range ((2**addrbits)-1) downto 0) of std_logic_vector(databits-1 downto 0);
shared variable ram : ram_type;

begin

-- Port A
process (rdclock)
begin
	if (rdclock'event and rdclock = '1') then
		q <= ram(to_integer(unsigned(rdaddress)));
	end if;
end process;

-- Port B
process (wrclock)
begin
	if (wrclock'event and wrclock = '1') then
		if wren='1' then
			ram(to_integer(unsigned(wraddress))) := data;
		end if;
	end if;
end process;


end architecture;
