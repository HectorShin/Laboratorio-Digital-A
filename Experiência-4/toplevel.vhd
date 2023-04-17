-- toplevel
library ieee;
use ieee.std_logic_1164.all;

entity toplevel is
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
end entity;

architecture topleve_arch of toplevel is
    -- sinais
        signal data_rx : std_logic_vector(8 downto 0);
        signal paridade_rx : std_logic;
        signal clock_projeto : std_logic;
        signal data_out : std_logic_vector(47 downto 0);
        signal data_out1 : std_logic_vector(7 downto 0);
        signal data_out2 : std_logic_vector(7 downto 0);
        signal data_out3 : std_logic_vector(7 downto 0);
        signal data_out4 : std_logic_vector(7 downto 0);
        signal data_out5 : std_logic_vector(7 downto 0);
        signal data_out6 : std_logic_vector(7 downto 0);

    -- componentes
        component projeto is
            port(
                dado_in : in std_logic_vector(8 downto 0); --Dados de saida do RX
                clock_in : in std_logic; --Fim do RX
                dado_out : out std_logic_vector(47 downto 0); -- Saida com capacidade de 6 caracteres    
                paridade: in std_logic
            );
        end component;
        component rx is
            generic (baudrate : integer := 380);
            port (
                clock : in std_logic; --Entrar com o clock de 50MHz do FPGA
                reset : in std_logic; --Reset, Lembre q o FPGA é active low, se aperta o botao o reset vai para 0
                sin : in std_logic; --Entrada da antena
                dado : out std_logic_vector(8 downto 0); --Saida do receptor
                paridade : out std_logic; --Saida da paridade
                fim : out std_logic --Sinal de controle da saida, So ler o valor de dado quando este sinal estiver em 1
            );
        end component;
        component display is
            port (
                input: in   std_logic_vector(7 downto 0); -- ASCII 8 bits
                output: out std_logic_vector(7 downto 0)  -- ponto + abcdefg
            );
        end component;
    begin 
        get_palavra : projeto port map(data_rx, clock_projeto, data_out, paridade_rx);
        get_caracteres : rx generic map(380) port map(clock, reset, data, data_rx, paridade_rx, clock_projeto);
        d1 : display port map(data_out1, display1);
        d2 : display port map(data_out2, display2);
        d3 : display port map(data_out3, display3);
        d4 : display port map(data_out4, display4);
        d5 : display port map(data_out5, display5);
        d6 : display port map(data_out6, display6);
        data_out1 <= data_out(7 downto 0);
        data_out2 <= data_out(15 downto 8);
        data_out3 <= data_out(23 downto 16);
        data_out4 <= data_out(31 downto 24);
        data_out5 <= data_out(39 downto 32);
        data_out6 <= data_out(47 downto 40);
    end architecture;
