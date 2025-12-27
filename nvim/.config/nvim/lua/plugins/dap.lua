return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "mfussenegger/nvim-dap-python",
    "nvim-neotest/nvim-nio",
    "mason-org/mason.nvim",
  },
  -- Keymaps are now defined here for better lazy-loading and documentation
  keys = {
    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "Debug: Continue",
    },
    {
      "<F10>",
      function()
        require("dap").step_over()
      end,
      desc = "Debug: Step Over",
    },
    {
      "<F11>",
      function()
        require("dap").step_into()
      end,
      desc = "Debug: Step Into",
    },
    {
      "<F12>",
      function()
        require("dap").step_out()
      end,
      desc = "Debug: Step Out",
    },

    -- Breakpoints
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debug: Toggle Breakpoint",
    },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Debug: Breakpoint Condition",
    },
    {
      "<leader>lp",
      function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end,
      desc = "Debug: Log Point",
    },

    -- Utilities
    {
      "<leader>dr",
      function()
        require("dap").repl.open()
      end,
      desc = "Debug: Open REPL",
    },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "Debug: Run Last",
    },
    {
      "<leader>du",
      function()
        require("dapui").toggle()
      end,
      desc = "Debug: Toggle UI",
    },
    {
      "<leader>dt",
      function()
        require("dap").terminate()
      end,
      desc = "Debug: Terminate",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local dap_virtual_text = require("nvim-dap-virtual-text")
    -- Setup DAP UI
    dapui.setup()
    -- Setup virtual text
    dap_virtual_text.setup()
    -- DAP signs
    vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "🔵", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "🟡", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "🟢", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "❌", texthl = "", linehl = "", numhl = "" })
    -- Java DAP configuration (jdtls provides this automatically with debug bundles)
    dap.configurations.java = {
      {
        type = "java",
        request = "launch",
        name = "Debug (Launch) - Current File",
        mainClass = "${file}",
      },
      {
        type = "java",
        request = "launch",
        name = "Debug (Launch) - Main Class",
        mainClass = function()
          return vim.fn.input("Main class: ", "", "file")
        end,
      },
    }
    -- Python DAP configuration
    require("dap-python").setup("python")
    -- TypeScript/JavaScript DAP configuration
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }
    dap.configurations.javascript = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }
    dap.configurations.typescript = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
        runtimeExecutable = "node",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }
    dap.configurations.typescriptreact = dap.configurations.typescript
    -- Optional: Uncomment to automatically open/close UI when debugging starts/stops
    -- dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    -- dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    -- dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
  end,
}
