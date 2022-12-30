-- Copyright (c) 2022 Gyorgy Szombathelyi
--
-- All rights reserved
--
-- Redistribution and use in source and synthezised forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- Redistributions of source code must retain the above copyright notice,
-- this list of conditions and the following disclaimer.
--
-- Redistributions in synthesized form must reproduce the above copyright
-- notice, this list of conditions and the following disclaimer in the
-- documentation and/or other materials provided with the distribution.
--
-- Neither the name of the author nor the names of other contributors may
-- be used to endorse or promote products derived from this software without
-- specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
--
-- Please report bugs to the author, but before you do so, please
-- make sure that this is not a derivative work and that
-- you have the latest version of this file.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity gen_4wayplay is
	port(
		RST_N  : in  std_logic;
		CLK    : in  std_logic;

		-- outputs from 4 controllers
		DATA   : in  std_logic_vector(7 downto 0);
		DATB   : in  std_logic_vector(7 downto 0);
		DATC   : in  std_logic_vector(7 downto 0);
		DATD   : in  std_logic_vector(7 downto 0);

		-- 1st controller output
		DOUT1  : out std_logic_vector(7 downto 0);

		-- 2nd controller port pins
		DAT2   : in  std_logic_vector(7 downto 0);
		DOUT2  : out std_logic_vector(7 downto 0);
		CTL2   : in  std_logic_vector(7 downto 0)  -- output enable
	);
end gen_4wayplay;

architecture rtl of gen_4wayplay is

signal SEL : std_logic_vector(2 downto 0);

begin

DOUT1 <= DATA when SEL = "000" else
         DATB when SEL = "001" else
         DATC when SEL = "010" else
         DATD when SEL = "011" else
         x"70";

DOUT2 <= DAT2 or not CTL2;

process( RST_N, CLK )
begin
	if RST_N = '0' then
		SEL <= "100";
	elsif rising_edge(CLK) then
		if CTL2(6 downto 4) = "111" then
			SEL <= DAT2(6 downto 4);
		end if;
	end if;
end process;

end rtl;
