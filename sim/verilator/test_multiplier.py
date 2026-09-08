import cocotb
import numpy as np
from cocotb.triggers import Timer

import utils


@cocotb.test()
async def test_combinational_complex_multiplier(dut):
    """Compare the packed complex multiplier with an integer reference model."""
    np.random.seed(0xC0DE)
    sample_count = 1000

    a_real = utils.generate_data_vector(sample_count)
    a_imag = utils.generate_data_vector(sample_count)
    b_real = utils.generate_data_vector(sample_count)
    b_imag = utils.generate_data_vector(sample_count)

    a_packed = utils.pack_real_imag_vec(a_real, a_imag)
    b_packed = utils.pack_real_imag_vec(b_real, b_imag)

    for index in range(sample_count):
        dut.a.value = int(a_packed[index])
        dut.b.value = int(b_packed[index])
        await Timer(1, unit="ns")

        result = np.array([int(dut.result.value)], dtype=np.uint64)
        actual_real, actual_imag = utils.unpack_real_imag_vec(result, np.int32)

        expected_real = int(a_real[index]) * int(b_real[index]) \
            - int(a_imag[index]) * int(b_imag[index])
        expected_imag = int(a_real[index]) * int(b_imag[index]) \
            + int(a_imag[index]) * int(b_real[index])

        assert int(actual_real[0]) == expected_real, (
            f"Real mismatch at index {index}: "
            f"DUT={actual_real[0]}, expected={expected_real}"
        )
        assert int(actual_imag[0]) == expected_imag, (
            f"Imaginary mismatch at index {index}: "
            f"DUT={actual_imag[0]}, expected={expected_imag}"
        )
