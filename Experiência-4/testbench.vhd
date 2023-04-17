library ieee;
use ieee.std_logic_1164.all;

entity teste is
end teste;

architecture teste_arch of teste is
    -- Device Under Test
        component toplevel is
            port (
                data:  in std_logic;
                clock : in std_logic;
                reset : in std_logic;
                display1 : out std_logic_vector(7 downto 0);
                display2 : out std_logic_vector(7 downto 0);
                display3 : out std_logic_vector(7 downto 0);
                display4 : out std_logic_vector(7 downto 0);
                display5 : out std_logic_vector(7 downto 0);
                display6 : out std_logic_vector(7 downto 0)
            );
        end component;
    -- Sinais de conexao 
        signal data_in : std_logic;
        signal clock_in : std_logic;
        signal reset_in : std_logic;
        signal display1_out : std_logic_vector(7 downto 0);
        signal display2_out : std_logic_vector(7 downto 0);
        signal display3_out : std_logic_vector(7 downto 0);
        signal display4_out : std_logic_vector(7 downto 0);
        signal display5_out : std_logic_vector(7 downto 0);
        signal display6_out : std_logic_vector(7 downto 0);
    -- Sinal do clock;
        constant periodoClock : time := 20 ns;

    begin
        
        
end architecture;