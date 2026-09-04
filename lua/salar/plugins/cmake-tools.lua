return {
	"Civitasv/cmake-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local cmake = require("cmake-tools")

		cmake.setup({
			cmake_command = "cmake",
			ctest_command = "ctest",
			cmake_regenerate_on_save = true,
			cmake_generate_options = {
				"-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
			},
			cmake_build_directory = "build",
			cmake_build_options = {},
			cmake_console_size = 10,
			cmake_show_console = "always",
			cmake_dap_configuration = {
				name = "Launch",
				type = "codelldb",
				request = "launch",
				program = "${workspaceFolder}/build/${workspaceFolderBasename}",
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
			cmake_always_use_terminal = false,
			cmake_terminal_options = {
				horizontal = { size = 10 },
			},
		})

		local keymap = vim.keymap

		-- CMake configure
		keymap.set("n", "<leader>cc", function()
			cmake.configure()
		end, { desc = "CMake configure" })

		-- CMake build
		keymap.set("n", "<leader>cb", function()
			cmake.build()
		end, { desc = "CMake build" })

		-- CMake clean
		keymap.set("n", "<leader>cx", function()
			cmake.clean()
		end, { desc = "CMake clean" })

		-- CMake build and run
		keymap.set("n", "<leader>cr", function()
			cmake.run()
		end, { desc = "CMake build and run" })

		-- CMake run target
		keymap.set("n", "<leader>cT", function()
			cmake.run_target()
		end, { desc = "CMake run target" })

		-- CMake build type (Debug/Release)
		keymap.set("n", "<leader>cs", function()
			cmake.select_cmake_kit()
		end, { desc = "CMake select kit" })

		keymap.set("n", "<leader>ct", function()
			cmake.select_build_type()
		end, { desc = "CMake select build type" })

		-- CMake quick run tests
		keymap.set("n", "<leader>cl", function()
			cmake.run_test()
		end, { desc = "CMake run tests" })

		-- CMake stop
		keymap.set("n", "<leader>cq", function()
			cmake.stop()
		end, { desc = "CMake stop" })
	end,
}
