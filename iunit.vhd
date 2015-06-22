LIBRARY	ieee;
USE		ieee.std_logic_1164.all;

entity iunit is
	port(
		CLK, RESET								: in  STD_LOGIC;
		INSTRUCTION, ALURESULT, ALUOUT	: in  STD_LOGIC_VECTOR(31 downto 0);
		PCENABLE									: in  STD_LOGIC;
		PCSOURCE									: in  STD_LOGIC_VECTOR(1 downto 0);
		PC											: out STD_LOGIC_VECTOR(31 downto 0)
	);
end entity;

architecture iunit_arch of iunit is

component mux4 is
	generic(
		LARGURA	: natural := 1
	);

	port(	
		a, b, c, d	: in  STD_LOGIC_VECTOR(LARGURA - 1 downto 0);
		sel			: in  STD_LOGIC_VECTOR(1 downto 0);
		q				: out STD_LOGIC_VECTOR(LARGURA - 1 downto 0)
	);
end component;

signal pcin, pcout, jumpAddr	: STD_LOGIC_VECTOR(31 downto 0);

begin
	mux1: mux4 generic map(32) port map(ALURESULT, ALUOUT, jumpAddr, x"FF_FF_FF_FF", PCSOURCE, pcin);
	
	PC <= pcout;
	
	-- PC register
	process(RESET, CLK, pcin)
	begin
		if (RESET = '0') then
			pcout <= x"00_00_00_00";
		elsif rising_edge(CLK) then
			pcout <= pcin;
		end if;
	end process;
	
	jumpAddr(1 downto 0)		<= "00";
	jumpAddr(27 downto 2)	<= INSTRUCTION(25 downto 0);
	jumpAddr(31 downto 28)	<= pcout(31 downto 28);
	
end;
