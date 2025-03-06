library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EX_REG is
    Port ( Clock : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           WrEn : in  STD_LOGIC;
           DataIn : in  STD_LOGIC_VECTOR (5 downto 0);
           DataOut : out  STD_LOGIC_VECTOR (5 downto 0));
end EX_REG;

architecture Behavioral of EX_REG is

signal temp: STD_LOGIC_VECTOR (5 downto 0);

begin

process(Clock,Reset)
	begin
		IF Reset = '1' THEN
			temp <= "000000";
		ELSIF rising_edge(Clock) THEN
			IF WrEn='1' THEN temp <= DataIn;
			END IF;
		END IF;
	end process;
	
	DataOut <= temp after 5 ns;

end Behavioral;
