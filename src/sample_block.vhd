library ieee;
use ieee.std_logic_1164.all;
use work.matrix_type.all;

entity sample_block is
   generic (
      G_BITS_MIC : integer := 24; -- Defines the resulotion of a mic sample
      G_NR_MICS  : integer := 64  -- Number of microphones in the Matrix
   );

   port (
      clk                : in std_logic;
      reset              : in std_logic;
      ws                 : in std_logic;
      bit_stream_array   : in std_logic_vector(3 downto 0);
      matrix_4_16_24_out : out matrix_4_16_24_type;
      ws_error_v         : out std_logic_vector(3 downto 0);
      data_valid_out     : out std_logic --  A signal to tell the receiver to start reading the data_out_matrix
   );
end entity;

architecture structual of sample_block is

   signal data_valid_in_ary            : std_logic_vector(3 downto 0);
   signal data_internal_matrix_4_16_24 : matrix_4_16_24_type;
begin
   sample_machine_gen : for i in 0 to 3 generate
   begin
      sample_machines : entity work.sample_machine
         port map(
            clk                   => clk,
            reset                 => reset,
            ws                    => ws,
            bit_stream            => bit_stream_array (i),
            ws_error              => ws_error_v(i),
            data_matrix_16_24_out => data_internal_matrix_4_16_24(i),
            data_valid_out        => data_valid_in_ary (i)
         );
   end generate sample_machine_gen;

   full_sample : entity work.full_sample
      port map(
         clk                => clk,
         reset              => reset,
         matrix_4_16_24_out => matrix_4_16_24_out,
         data_in_matrix_1   => data_internal_matrix_4_16_24(0),
         data_in_matrix_2   => data_internal_matrix_4_16_24(1),
         data_in_matrix_3   => data_internal_matrix_4_16_24(2),
         data_in_matrix_4   => data_internal_matrix_4_16_24(3),
         data_valid_in_ary  => data_valid_in_ary,
         data_valid_out     => data_valid_out
      );
end structual;