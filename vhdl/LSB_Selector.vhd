library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LSB_Selector is
    Port ( byteFlag : in  STD_LOGIC;
           DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
           DataOut : out  STD_LOGIC_VECTOR (31 downto 0));
end LSB_Selector;

architecture Behavioral of LSB_Selector is

begin
	DataOut <= ("000000000000000000000000" & DataIn(7 downto 0)) when byteFlag = '1' else
				 DataIn;
end Behavioral;