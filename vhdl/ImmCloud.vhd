library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity ImmCloud is
		Port ( DataIn : in  STD_LOGIC_VECTOR (15 downto 0);
				 OpCode : in  STD_LOGIC_VECTOR (5 downto 0);
				 ImmExt : in STD_LOGIC;
				 ImmOut : out  STD_LOGIC_VECTOR (31 downto 0));
end ImmCloud;

architecture Behavioral of ImmCloud is

signal temp : STD_LOGIC_VECTOR(31 downto 0);
begin
		process(OpCode, DataIn, ImmExt)
		Begin
		
		if(OpCode="111111" or OpCode="000000" or OpCode="000001") then -- sign extend and shift left 2
				if (DataIn(15)='0') then
					temp(31 downto 18) <= "00000000000000";
					temp(17 downto 2) <= DataIn;
					temp(1 downto 0) <= "00";
				else
					temp(31 downto 18) <= "11111111111111";
					temp(17 downto 2) <= DataIn;
					temp(1 downto 0) <= "00";
				End if;
				
			elsif(OpCode="111001") then -- shift 16 and zero fill
				
					temp(31 downto 16) <= DataIn;
					temp(15 downto 0) <= "0000000000000000";
					
			
			elsif (ImmExt='0') then -- ZeroFill
				temp(31 downto 16) <= "0000000000000000";
				temp(15 downto 0) <= DataIn;
			else 						-- SignExtend
				if (DataIn(15)='0') then
					temp(31 downto 16) <= "0000000000000000";
					temp(15 downto 0) <= DataIn;
				else
					temp(31 downto 16) <= "1111111111111111";
					temp(15 downto 0) <= DataIn;
				End if;
			End if;
			
			
			
				
		End Process;
		ImmOut <= temp; 
 
end Behavioral;