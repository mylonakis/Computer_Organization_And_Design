library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;


entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           OP : in  STD_LOGIC_VECTOR (3 downto 0);
           COUT : out  STD_LOGIC;
           ZERO : out  STD_LOGIC;
           OVF : out  STD_LOGIC;
           AOUT : out  STD_LOGIC_VECTOR (31 downto 0));
end ALU;

architecture Behavioral of ALU is

signal ALU_RESULT : STD_LOGIC_VECTOR(31 downto 0);
signal tmp : std_logic_vector(32 downto 0);

begin

	process(A,B,OP)
	begin
	case(OP) is

      when "0000" => 
		ALU_RESULT <= A+B;
      when "0001" => 
		ALU_RESULT <= A-B;
      when "0010" => 
		ALU_RESULT <= (A nand B);
      when "0011" => 
		ALU_Result <= (A or B);
      when "0100" => 
		ALU_Result <= (not A);
      when "1000" =>
		ALU_Result <= A(31)&A(31 downto 1);
		when "1001" => 
		ALU_Result <= std_logic_vector(unsigned(A) sll 1);
      when "1010" =>  
		ALU_Result <= std_logic_vector(unsigned(A) srl 1);
		when "1100" =>
		ALU_Result <= std_logic_vector(unsigned(A) rol 1);
		when "1101" =>
		ALU_Result <= std_logic_vector(unsigned(A) ror 1);
		when others => null;
		
      end case;

   end process;
	
	process(ALU_Result,tmp)
	begin 
	if ALU_Result = "00000000000000000000000000000000" then
		ZERO <= '1' after 10 ns;
	else
	ZERO <= '0' after 10 ns;
	end if;
		if (tmp(32)xor ALU_Result(31)) = '1' then
		OVF <='1' after 10 ns;
		else OVF <='0' after 10 ns;
		end if;
		end process;
	
	
	AOUT<= ALU_Result after 10 ns; 
	tmp <= ('0' & A) + ('0' & B);
   COUT <= tmp(32) after 10 ns; -- Carryout flag
	
end Behavioral;

