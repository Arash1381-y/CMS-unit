import cocotb
import utils
import numpy as np
from cocotb.triggers import Timer

@cocotb.test()
async def test_combinational_adder_subtractor(dut):
    """Test for a purely combinational Adder/Subtractor Unit"""
    dut._log.info("Starting test for Adder/Subtractor")

    N = 1000
    a_real = utils.generate_data_vector(N)
    a_imag = utils.generate_data_vector(N)
    b_real = utils.generate_data_vector(N)
    b_imag = utils.generate_data_vector(N)

    a_packed = utils.pack_real_imag_vec(a_real, a_imag)
    b_packed = utils.pack_real_imag_vec(b_real, b_imag)


    dut._log.info("Testing Addition (addNotSub = 1)")
    dut.addNotSub.value = 1
    for i in range(N):
        dut.a.value = int(a_packed[i])
        dut.b.value = int(b_packed[i])

        await Timer(1, units='ns')
        dut._log.info(f"a={utils.to_complex(dut.a.value)}, b={utils.to_complex(dut.b.value)}")

        result = dut.result.value.integer
        dut_real, dut_imag = utils.unpack_real_imag_vec(np.array([result]), np.int16)

        expected_real = a_real[i] + b_real[i]
        expected_imag = a_imag[i] + b_imag[i]

        assert dut_real[0] == expected_real, (
            f"Addition Real mismatch @ index {i}: DUT={dut_real[0]}, Expected={expected_real}"
        )
        assert dut_imag[0] == expected_imag, (
            f"Addition Imag mismatch @ index {i}: DUT={dut_imag[0]}, Expected={expected_imag}"
        )


    dut._log.info("Testing Subtraction (addNotSub = 0)")
    dut.addNotSub.value = 0
    for i in range(N):
        dut.a.value = int(a_packed[i])
        dut.b.value = int(b_packed[i])

        await Timer(1, units='ns')
        dut._log.info(f"a={utils.to_complex(dut.a.value)}, b={utils.to_complex(dut.b.value)}")

        result = dut.result.value.integer
        dut_real, dut_imag = utils.unpack_real_imag_vec(np.array([result]), np.int16)

        expected_real = a_real[i] - b_real[i]
        expected_imag = a_imag[i] - b_imag[i]

        assert dut_real[0] == expected_real, (
            f"Subtraction Real mismatch @ index {i}: DUT={dut_real[0]}, Expected={expected_real}"
        )
        assert dut_imag[0] == expected_imag, (
            f"Subtraction Imag mismatch @ index {i}: DUT={dut_imag[0]}, Expected={expected_imag}"
        )

    dut._log.info("Test finished successfully!")