library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;



entity Decoder is
    Port ( DecIn : in  STD_LOGIC_VECTOR (4 downto 0):="00000";
           DecOut : out  STD_LOGIC_VECTOR (31 downto 0):="00000000000000000000000000000000");
end Decoder;

architecture Behavioral of Decoder is

signal temp: STD_LOGIC_VECTOR (31 downto 0);

begin
	
	forGenerate:
	for i in 0 to 31 generate
			temp(i) <= '1' when DecIn = i else '0';
	end generate;
	
	DecOut <= temp after 5 ns;

end Behavioral;