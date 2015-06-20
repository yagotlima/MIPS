LIBRARY	ieee;
USE		ieee.std_logic_1164.all;

entity control is
	port(
		OP									: in  STD_LOGIC_VECTOR(5 downto 0);
		REGDST, ALUSRC, MEMTOREG	: out STD_LOGIC;
		REGWRITE, MEMREAD				: out STD_LOGIC;
		MEMWRITE, BRANCH, JUMP		: out STD_LOGIC;
		ALUOP								: out STD_LOGIC_VECTOR(1 downto 0)
	);
end entity;

architecture control_arch of control is

constant Rtype	: STD_LOGIC_VECTOR(5 downto 0) := "000000";
constant Addi	: STD_LOGIC_VECTOR(5 downto 0) := "001000";
constant Lw		: STD_LOGIC_VECTOR(5 downto 0) := "100011";
constant Sw		: STD_LOGIC_VECTOR(5 downto 0) := "101011";
constant Beq	: STD_LOGIC_VECTOR(5 downto 0) := "000100";
constant j		: STD_LOGIC_VECTOR(5 downto 0) := "000010";

begin
	REGDST	<= '1' when OP = Rtype else '0';
	ALUSRC	<= '1' when OP = Addi or OP = Lw or OP = Sw else '0';
	MEMTOREG	<= '1' when OP = Lw else '0';
	REGWRITE	<= '1' when OP = RType or OP = Addi or OP = Lw else '0';
	MEMREAD	<= '1' when OP = Lw else '0';
	MEMWRITE	<= '1' when OP = Sw else '0';
	BRANCH	<= '1' when OP = Beq else '0';
	JUMP		<= '1' when Op = j else '0';
	
	with OP select
		ALUOP <= "01" when Beq,
					"10" when Rtype,
					"00" when others;
end;
