local M = {}

local Job = require "plenary.job"

M.setup = function(_)
end

M.install_stubs = function(python_exec)
    local log_file = vim.fn.stdpath("log") .. "/boto3-nvim.log"
    python_exec = python_exec or "python"

    if vim.fn.executable(python_exec) ~= 1 then
        python_exec = "python3"
    end
    if vim.fn.executable(python_exec) ~= 1 then
        print("python executable not found on path")
        return
    end

    M.install_if_missing(python_exec, log_file)
end

M.install_if_missing = function(python_exec, log_file)
    vim.env.PATH = "/private/tmp/venv/bin:" .. vim.env.PATH
    local cmd = "exec(\"import importlib;importlib.import_module('boto3-stubs')\")"
    Job:new({
        command = python_exec,
        args = { "-c", cmd },
        on_stdout = function(_, line)
            vim.schedule(function()
                vim.fn.writefile({ line }, log_file, "a")
            end)
        end,
        on_stderr = function(_, line)
            vim.schedule(function()
                vim.fn.writefile({ line }, log_file, "a")
            end)
        end,
        on_exit = function(_, return_val)
            if return_val == 0 then
                print("boto3 stubs installed")
            else
                M.execute_install(python_exec, log_file)
            end
        end,
    }):start()
end

M.execute_install = function(python_exec, log_file)
    print("Installing boto3 stubs")
    vim.schedule(function()
        vim.fn.writefile({ "Installing boto3 stubs" }, log_file)
    end)

    Job:new({
        command = python_exec,
        args = { "-m", "pip", "install", "boto3-stubs[essential]" },
        on_stdout = function(_, line)
            vim.schedule(function()
                vim.fn.writefile({ line }, log_file, "a")
            end)
        end,
        on_stderr = function(_, line)
            vim.schedule(function()
                vim.fn.writefile({ line }, log_file, "a")
            end)
        end,
        on_exit = function(_, _)
            print('boto3 stubs installed')
        end,
    }):start()
end

return M
