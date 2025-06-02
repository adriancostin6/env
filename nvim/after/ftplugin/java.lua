-- +-----+
-- | LSP |
-- +-----+----------------------------------------------------------------------
local jdtls
if vim.loop.os_uname().sysname == 'Windows_NT' then
  jdtls = 'jdtls.cmd'
else
  jdtls = 'jdtls'
end

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local project = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace = vim.env.HOME .. '/.nvim-jdtls/' .. project

local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    -- 💀
    'java', -- or '/path/to/java17_or_newer/bin/java'
            -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    -- 💀
    -- TODO: change based on OS and wildcard for version
    '-jar', vim.fn.stdpath('data') .. '/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
         -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
         -- Must point to the                                                     Change this to
         -- eclipse.jdt.ls installation                                           the actual version


    -- 💀
    -- TODO: change based on OS
    '-configuration', vim.fn.stdpath('data') .. '/mason/packages/jdtls/config_linux',
                    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
                    -- Must point to the                      Change to one of `linux`, `win` or `mac`
                    -- eclipse.jdt.ls installation            Depending on your system.


    -- 💀
    -- See `data directory configuration` section in the README
    '-data', workspace
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require('jdtls.setup').find_root({'.mark', '.git', 'mvnw', 'gradlew'}),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      project = {
        -- Problem: jdtls won't find dependendencies automatically if not a maven project
        -- Solution: specify dependencies manually
        referencedLibraries = {
            --TODO: think of how to specify this per project
            vim.env.SILVER_HOME .. '/test/regression-test/GUI/sikuli/jar/linux/sikulixapi-2.0.5-modified-lux.jar',
        },

        -- Problem: Default path is "src/main/java" (https://github.com/mfussenegger/nvim-jdtls/discussions/609#discussioncomment-8212164)
        -- Causes: Declared package <name> does not match "" if sources are in a custom named folder
        -- Solution: Overwrite default using sourcePaths (https://github.com/eclipse-jdtls/eclipse.jdt.ls/issues/1764#issuecomment-834767160)
        sourcePaths = {
            'src'
        },
        outputPath = {
            'out'
        }
      }
    }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {}
  },
}

require'jdtls'.start_or_attach(config)
