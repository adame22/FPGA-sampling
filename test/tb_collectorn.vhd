LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

ENTITY tb_collectorn IS
    GENERIC (
        runner_cfg : STRING
    );
END tb_collectorn;

ARCHITECTURE tb OF tb_collectorn IS
    CONSTANT clk_cykle : TIME := 10 ns;
    SIGNAL nr_clk : INTEGER := 0; --anv�nds inte �n

    COMPONENT collectorn
        PORT (
            data_in : in std_logic;
            clk : in std_logic;
            rst : in std_logic;
            mic_1 : out std_logic_vector(7 downto 0);
            mic_2 : out std_logic_vector(7 downto 0);
            mic_3 : out std_logic_vector(7 downto 0);
            mic_4 : out std_logic_vector(7 downto 0)
        );
    END COMPONENT;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL data_in : STD_LOGIC;
    SIGNAL rst : STD_LOGIC := '0';
    SIGNAL v : STD_LOGIC_VECTOR(9 DOWNTO 0) := "101101110001011101001101110101111011010101011010101010110101010110111010101000010111111010101112"; --test number sequense 8*12 
    SIGNAL mic_1 : std_logic_vector(7 downto 0);
    SIGNAL mic_2 : std_logic_vector(7 downto 0);
    SIGNAL mic_3 : std_logic_vector(7 downto 0);
    SIGNAL mic_4 : std_logic_vector(7 downto 0);

BEGIN

    collector1 : collectorn PORT MAP(
        data_in => data_in,
        clk => clk,
        rst => rst,
        mic_1 => mic_1,
        mic_2 => mic_2,
        mic_2 => mic_2,
        mic_2 => mic_2
    );

    clk <= NOT clk AFTER clk_cykle / 2;

    main : PROCESS
    BEGIN
        test_runner_setup(runner, runner_cfg);
        WHILE test_suite LOOP
            IF run("Test_1") THEN

                

            ELSIF run("Test_2") THEN
                --assert message = "set-for-test";
                --dump_generics;

                data_in <= '1';

                WAIT FOR 10 ns; --total tid f�r test 2

                ASSERT (data_in = '0')
                REPORT "demo error 1"
                    SEVERITY warning;

                ASSERT (1 = 0)
                REPORT "demo error 2"
                    SEVERITY warning;
                check(data_in = '0', "1 test med flera checks");
                check(1 = 0, "2 test med flera checks");
                check(1 = 1, "3 test med flera checks");

            END IF;
        END LOOP;

        test_runner_cleanup(runner);
    END PROCESS;

    test_runner_watchdog(runner, 100 ms);
END ARCHITECTURE;