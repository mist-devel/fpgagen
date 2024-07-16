library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity gen_cart is
port(
	reset_n        : in std_logic;
	MCLK           : in std_logic;  -- 54MHz
	DL_CLK         : in std_logic;

	ext_reset_n  : in std_logic := '1';
	ext_bootdone : in std_logic := '0';
	ext_data     : in std_logic_vector(15 downto 0) := (others => '0');
	ext_data_ack : in std_logic := '0';

	svp_en       : out std_logic
);

end entity;


architecture rtl of gen_cart is

signal romwr_a : unsigned(23 downto 1);
signal cart_id : std_logic_vector(87 downto 0);

function to_slv(s: string) return std_logic_vector is
  constant ss: string(1 to s'length) := s;
  variable rval: std_logic_vector(1 to 8 * s'length);
  variable p: integer;
  variable c: integer;
begin
  for i in ss'range loop
    p := 8 * i;
    c := character'pos(ss(i));
    rval(p - 7 to p) := std_logic_vector(to_unsigned(c,8));
  end loop;
  return rval;
end function;

begin

	process (DL_CLK) begin
		if rising_edge( DL_CLK ) then
			if ext_reset_n = '0' then
				romwr_a <= (others => '0');
				svp_en <= '0';
			elsif ext_data_ack = '1' then
				romwr_a <= romwr_a + 1;
				if(romwr_a = 384/2) then cart_id(87 downto 72) <= ext_data; end if;
				if(romwr_a = 386/2) then cart_id(71 downto 56) <= ext_data; end if;
				if(romwr_a = 388/2) then cart_id(55 downto 40) <= ext_data; end if;
				if(romwr_a = 390/2) then cart_id(39 downto 24) <= ext_data; end if;
				if(romwr_a = 392/2) then cart_id(23 downto  8) <= ext_data; end if;
				if(romwr_a = 394/2) then cart_id( 7 downto  0) <= ext_data(15 downto 8); end if;
			elsif ext_bootdone = '1' then
				if   (cart_id(63 downto 0) = to_slv("MK-1229 ")) then svp_en <= '1';    -- Virtua Racing EU/US
				elsif(cart_id(63 downto 0) = to_slv("G-7001  ")) then svp_en <= '1';    -- Virtua Racing JP
				end if;
			end if;
		end if;
	end process;

end rtl;
