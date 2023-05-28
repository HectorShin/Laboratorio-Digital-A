-- toplevel
library ieee;
use ieee.std_logic_1164.all;

entity toplevel is
    port (
        data : in std_logic;
        clock : in std_logic;
        reset : in std_logic;
        led : out std_logic;
        display1 : out std_logic_vector(7 downto 0);
        display2 : out std_logic_vector(7 downto 0);
        display3 : out std_logic_vector(7 downto 0);
        display4 : out std_logic_vector(7 downto 0);
        display5 : out std_logic_vector(7 downto 0);
        display6 : out std_logic_vector(7 downto 0)
    );
end entity;

architecture topleve_arch of toplevel is
    signal clock_in : std_logic;

    signal erro_int : std_logic_vector(3 downto 0);

    signal data_in : std_logic_vector(11 downto 0);
    signal data_out : std_logic_vector(7 downto 0);
    signal data_out_projeto : std_logic_vector(47 downto 0);
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
    signal key : std_logic_vector(47 downto 0);
    signal key_size : std_logic_vector(2 downto 0);
    signal getting_key : std_logic;
    signal data_out_cripto : std_logic_vector(7 downto 0);

    component rx is
        generic (baudrate : integer := 382);
        port (
            clock : in std_logic; --Entrar com o clock de 50MHz do FPGA
            reset : in std_logic; --Reset, Lembre q o FPGA é active low, se aperta o botao o reset vai para 0
            data_in : in std_logic; --Entrada da antena
            dado : out std_logic_vector(11 downto 0); --Saida do receptor
            paridade : out std_logic; --Saida da paridade
            fim : out std_logic --Sinal de controle da saida, So ler o valor de dado quando este sinal estiver em 1
        );
    end component;

    component projeto is
        port (
            dado_in : in std_logic_vector(7 downto 0); --Dados de saida do RX
            clock_in : in std_logic; --Fim do RX
            dado_out : out std_logic_vector(47 downto 0); -- Saida com capacidade de 6 caracteres
            led : out std_logic;
            pegando_chave : in std_logic
        );
    end component;

    component hamming is
        port(
            entrada: in std_logic_vector(11 downto 0);
            dados : out std_logic_vector(7 downto 0);  
            erro_int : out std_logic_vector(3 downto 0)         
        );
    end component;

    component display is
        port (
            input : in std_logic_vector(7 downto 0); -- ASCII 8 bits
            output : out std_logic_vector(7 downto 0) -- ponto + abcdefg
        );
    end component;

    component pega_chave is
        port(
            dados_chave : in std_logic_vector(7 downto 0);
            chave : out std_logic_vector(47 downto 0);
            clk : in std_logic;
            tamanho_chave : out std_logic_vector(2 downto 0);
            pegando_chave : out std_logic
        );
    end component;

    component criptografia is
        port(
            dados_cripto : in std_logic_vector(7 downto 0);
            chave: in std_logic_vector(47 downto 0);
            tamanho_chave : in std_logic_vector(2 downto 0);
            clk : in std_logic;
            dados_corrigido : out std_logic_vector(7 downto 0)
        );
    end component;

begin
    get_caracteres : rx generic map(384) port map(clock, reset, data, data_in, open, clock_in);
    hamming_teste : hamming port map(data_in, data_out, open);
    get_chave : pega_chave port map(data_out, key, clock_in, key_size, getting_key);
    cripto : criptografia port map(data_out, key, key_size, clock_in, data_out_cripto);
    junta_caractere_teste : projeto port map(data_out_cripto, clock_in, data_out_projeto, led, getting_key);

    d1 : display port map(data_out_projeto(7 downto 0), ndata_out1);
    d2 : display port map(data_out_projeto(15 downto 8), ndata_out2);
    d3 : display port map(data_out_projeto(23 downto 16), ndata_out3);
    d4 : display port map(data_out_projeto(31 downto 24), ndata_out4);
    d5 : display port map(data_out_projeto(39 downto 32), ndata_out5);
    d6 : display port map(data_out_projeto(47 downto 40), ndata_out6);
    
    display1 <= not(ndata_out1);
    display2 <= not(ndata_out2);
    display3 <= not(ndata_out3);
    display4 <= not(ndata_out4);
    display5 <= not(ndata_out5);
    display6 <= not(ndata_out6);
end architecture;
