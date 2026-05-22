-- Плагин для работы с зашифрованными файлами (*.enc)
-- Использует OpenSSL AES-256-CBC для шифрования

local M = {}

-- Функция расшифровки файла
local function decrypt_file()
    local filepath = vim.fn.expand('%:p')
    
    -- Проверяем существование файла
    if vim.fn.filereadable(filepath) == 0 then
        -- Новый файл - ничего не делаем
        return
    end
    
    -- Запрашиваем пароль
    local password = vim.fn.inputsecret('Введите пароль для расшифровки: ')
    if password == '' then
        vim.notify('Пароль не введен. Файл не будет расшифрован.', vim.log.levels.WARN)
        vim.cmd('bdelete!')
        return
    end
    
    -- Расшифровываем файл
    local cmd = string.format(
        'openssl aes-256-cbc -d -pbkdf2 -in %s -pass pass:%s 2>&1',
        vim.fn.shellescape(filepath),
        vim.fn.shellescape(password)
    )
    
    local handle = io.popen(cmd)
    local result = handle:read('*a')
    local success = handle:close()
    
    if not success then
        vim.notify('Ошибка расшифровки! Неверный пароль или поврежденный файл.', vim.log.levels.ERROR)
        vim.cmd('bdelete!')
        return
    end
    
    -- Загружаем расшифрованное содержимое в буфер
    local lines = vim.split(result, '\n')
    -- Удаляем последнюю пустую строку если она есть
    if lines[#lines] == '' then
        table.remove(lines)
    end
    
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.bo.modified = false
    
    vim.notify('Файл успешно расшифрован', vim.log.levels.INFO)
end

-- Функция шифрования файла
local function encrypt_file()
    local filepath = vim.fn.expand('%:p')
    
    -- Получаем содержимое буфера
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local content = table.concat(lines, '\n')
    
    -- Запрашиваем пароль
    local password = vim.fn.inputsecret('Введите пароль для шифрования: ')
    if password == '' then
        vim.notify('Пароль не введен. Файл не будет сохранен.', vim.log.levels.ERROR)
        return false
    end
    
    -- Для новых файлов запрашиваем подтверждение пароля
    if vim.fn.filereadable(filepath) == 0 then
        local password_confirm = vim.fn.inputsecret('Подтвердите пароль: ')
        if password ~= password_confirm then
            vim.notify('Пароли не совпадают! Файл не сохранен.', vim.log.levels.ERROR)
            return false
        end
    end
    
    -- Создаем временный файл для незашифрованного содержимого
    local tmpfile = vim.fn.tempname()
    local f = io.open(tmpfile, 'w')
    if not f then
        vim.notify('Ошибка создания временного файла', vim.log.levels.ERROR)
        return false
    end
    f:write(content)
    f:close()
    
    -- Шифруем файл
    local cmd = string.format(
        'openssl aes-256-cbc -e -pbkdf2 -in %s -out %s -pass pass:%s 2>&1',
        vim.fn.shellescape(tmpfile),
        vim.fn.shellescape(filepath),
        vim.fn.shellescape(password)
    )
    
    local handle = io.popen(cmd)
    local result = handle:read('*a')
    local success = handle:close()
    
    -- Удаляем временный файл
    os.remove(tmpfile)
    
    if not success then
        vim.notify('Ошибка шифрования: ' .. result, vim.log.levels.ERROR)
        return false
    end
    
    vim.bo.modified = false
    vim.notify('Файл успешно зашифрован и сохранен', vim.log.levels.INFO)
    return true
end

-- Настройка безопасности для зашифрованных файлов
local function setup_security()
    vim.opt_local.swapfile = false
    vim.opt_local.undofile = false
    vim.opt_local.backup = false
    vim.opt_local.writebackup = false
    vim.opt_local.viminfo = ''
end

-- Создаем autogroup для зашифрованных файлов
local augroup = vim.api.nvim_create_augroup('SecureFile', { clear = true })

-- При открытии *.enc файла
vim.api.nvim_create_autocmd('BufReadPost', {
    group = augroup,
    pattern = '*.enc',
    callback = function()
        setup_security()
        decrypt_file()
    end,
})

-- Перед сохранением - шифруем
vim.api.nvim_create_autocmd('BufWritePre', {
    group = augroup,
    pattern = '*.enc',
    callback = function()
        -- Отменяем стандартное сохранение
        vim.cmd('setlocal nomodified')
    end,
})

-- Вместо BufWritePre используем BufWriteCmd для полного контроля
vim.api.nvim_create_autocmd('BufWriteCmd', {
    group = augroup,
    pattern = '*.enc',
    callback = function()
        encrypt_file()
    end,
})

-- Команда для смены пароля
vim.api.nvim_create_user_command('SecureFileChangePassword', function()
    if not vim.fn.expand('%'):match('%.enc$') then
        vim.notify('Эта команда работает только с *.enc файлами', vim.log.levels.WARN)
        return
    end
    
    vim.notify('Сохраните файл для установки нового пароля', vim.log.levels.INFO)
    vim.bo.modified = true
end, {})

return M
