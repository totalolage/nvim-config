# Formatting and Testing Tools Integration

This document describes the integration of Biome, Prettier, and Vitest into the Neovim configuration.

## Automatic Formatter Detection

The configuration automatically detects which formatter to use for JavaScript/TypeScript files:

1. **If `biome.json` or `biome.jsonc` exists**: Uses Biome
2. **Otherwise**: Uses Prettier (default)

This detection happens automatically - no manual configuration needed!

## Biome

Biome is a fast formatter and linter for JavaScript/TypeScript projects.

### Usage

- **Manual formatting**: Use `<leader>fm` to format the current buffer (same as Prettier)
- **Configuration**: Create a `biome.json` or `biome.jsonc` file in your project root
- **Features**: Formatting, import organization, and linting (when formatting)

## Prettier

Prettier is the default formatter when no Biome configuration is detected.

### Usage

- **Manual formatting**: Use `<leader>fm` to format the current buffer
- **Configuration**: Create a `.prettierrc` file in your project root
- **Format on save**: Uncomment the `format_on_save` section in `conform.lua` if desired

## Vitest

Vitest test runner is now integrated alongside Jest.

### Test Commands

All test commands work for both Jest and Vitest:

- `<leader>tr` - Run nearest test
- `<leader>tR` - Run all tests in current file
- `<leader>tA` - Run all test files in project
- `<leader>tl` - Run last test
- `<leader>ts` - Toggle test summary
- `<leader>to` - Show test output
- `<leader>tO` - Toggle output panel
- `<leader>tS` - Stop running tests
- `<leader>tw` - Toggle watch mode for nearest test
- `<leader>tW` - Toggle watch mode for current file

### Requirements

- Ensure you have the TypeScript/JavaScript treesitter parsers installed
- Vitest should be installed in your project (`npm install -D vitest`)

## Choosing Between Tools

### Formatter Choice (Biome vs Prettier)

- **Use Biome when**: You want faster formatting and integrated linting
- **Use Prettier when**: You need specific Prettier plugins or have an existing Prettier configuration

### Test Runner Choice (Jest vs Vitest)

- **Both are supported**: Neotest will automatically detect which test runner your project uses
- Tests are identified by file patterns (`.test.js`, `.spec.ts`, etc.)

## Troubleshooting

1. **Biome not formatting**: Ensure you have a `biome.json` file in your project root
2. **Tests not found**: Check that treesitter parsers are installed (`:TSInstall javascript typescript`)
3. **Mason packages not installed**: Run `:Mason` and ensure all packages are installed