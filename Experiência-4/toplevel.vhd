-- toplevel
library ieee;
use ieee.std_logic_1164.all;

entity toplevel is
    port (
        data : in std_logic;
        clock : in std_logic;
        reset : in std_logic;
        display1 : out std_logic_vector(7 downto 0);
        display2 : out std_logic_vector(7 downto 0);
        display3 : out std_logic_vector(7 downto 0);
        display4 : out std_logic_vector(7 downto 0);
        display5 : out std_logic_vector(7 downto 0);
        display6 : out std_logic_vector(7 downto 0);
        paridade1 : out std_logic;
        paridade2 : out std_logic;
        paridade3 : out std_logic;
        paridade4 : out std_logic;
        paridade5 : out std_logic;
        paridade6 : out std_logic;
    );
end entity;

architecture topleve_arch of toplevel is
    signal clock_in : std_logic;
	 signal paridade : std_logic;
     signal paridades_out : std_logic_vector(5 downto 0);
    signal data_in : std_logic_vector(8 downto 0);
    signal data_out : std_logic_vector(47 downto 0);
    signal data_out1 : std_logic_vector(7 downto 0);
    signal data_out2 : std_logic_vector(7 downto 0);
    signal data_out3 : std_logic_vector(7 downto 0);
    signal data_out4 : std_logic_vector(7 downto 0);
    signal data_out5 : std_logic_vector(7 downto 0);
    signal data_out6 : std_logic_vector(7 downto 0);
    signal ndata_out1 : std_logic_vector(7 downto 0);
    signal ndata_out2 : std_logic_vector(7 downto 0);
    signal ndata_out3 : std_logic_vector(7 downto 0);
    signal ndata_out4 : std_logic_vector(7 downto 0);
    signal ndata_out5 : std_logic_vector(7 downto 0);
    signal ndata_out6 : std_logic_vector(7 downto 0);
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

    component projeto is
        port (
            dado_in : in std_logic_vector(8 downto 0); --Dados de saida do RX
            clock_in : in std_logic; --Fim do RX
            dado_out : out std_logic_vector(47 downto 0); -- Saida com capacidade de 6 caracteres
				paridade : in std_logic;
                paridades_out : out std_logic_vector(5 downto 0)
        );
    end component;

    component display is
        port (
            input : in std_logic_vector(7 downto 0); -- ASCII 8 bits
            output : out std_logic_vector(7 downto 0) -- ponto + abcdefg
        );
    end component;

begin
  get_caracteres : rx generic map(380) port map(clock, reset, data, data_in, paridade, clock_in);
  junta_caractere : projeto port map(data_in, clock_in, data_out, paridade, paridades_out);
  d1 : display port map(data_out1, ndata_out1);
  d2 : display port map(data_out2, ndata_out2);
  d3 : display port map(data_out3, ndata_out3);
  d4 : display port map(data_out4, ndata_out4);
  d5 : display port map(data_out5, ndata_out5);
  d6 : display port map(data_out6, ndata_out6);
  data_out6 <= data_out(7 downto 0);
  data_out5 <= data_out(15 downto 8);
  data_out4 <= data_out(23 downto 16);
  data_out3 <= data_out(31 downto 24);
  data_out2 <= data_out(39 downto 32);
  data_out1 <= data_out(47 downto 40);
  display1 <= not(ndata_out1);
  display2 <= not(ndata_out2);
  display3 <= not(ndata_out3);
  display4 <= not(ndata_out4);
  display5 <= not(ndata_out5);
  display6 <= not(ndata_out6);
  paridade1 <= paridades_out(0);
  paridade1 <= paridades_out(1);
  paridade1 <= paridades_out(2);
  paridade1 <= paridades_out(3);
  paridade1 <= paridades_out(4);
  paridade1 <= paridades_out(5);
end architecture;
