LIBRARY	ieee;
USE		ieee.std_logic_1164.all;

entity eunit is
	port(
		CLK, RESET								: in  STD_LOGIC;
		INSTRUCTION, MEMORYDATA, PC		: in  STD_LOGIC_VECTOR(31 downto 0);
		REGDST, MEMTOREG, REGWRITE			: in  STD_LOGIC;
		ALUSRCA									: in  STD_LOGIC;
		ALUSRCB									: in  STD_LOGIC_VECTOR(1 downto 0);
		ALUCONTROL								: in  STD_LOGIC_VECTOR(3 downto 0);
		ZERO										: out STD_LOGIC;
		ALURESULT, ALUOUT, WRITEDATA		: out STD_LOGIC_VECTOR(31 downto 0)
	);
end entity;

architecture eunit_arch of eunit is

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

signal wrRegister						: STD_LOGIC_VECTOR(4 downto 0);
signal wrData							: STD_LOGIC_VECTOR(31 downto 0);
signal aluResultSig, aluOutSig	: STD_LOGIC_VECTOR(31 downto 0);

begin
	ALUOUT <= aluOutSig;
	ALURESULT <= aluResultSig;

	wrRegister	<= INSTRUCTION(20 downto 16) when REGDST = '0' else INSTRUCTION(15 downto 11);
	wrData		<= aluOutSig when MEMTOREG = '0' else MEMORYDATA;
end;
