# Notes

Обычные заметки

## GIT Prompt customization

Клонируем из репозитория:

```linux
cd ~
git clone git@github.com:magicmonty/bash-git-prompt.git
```

Добавляем в `.bashrc` следующие строки

```linux
echo "" >> ~/.bashrc
echo "GIT_PROMPT_ONLY_IN_REPO=1" >> ~/.bashrc
echo "source ~/.bash-git-prompt/gitprompt.sh" >> ~/.bashrc
```

- `GIT_PROMPT_ONLY_IN_REPO=1` - включает отображение уведомлений гита только внутри репозитория
- `source ~/.bash-git-prompt/gitprompt.sh` - запускает скрипт, модифицирующий $PS1

Теперь создаем новый файл *~/.bash-git-prompt/themes/Custom_Single_Line_Dark.bgptheme* и вносим в него следующее:

```bash
# This is a theme for gitprompt.sh,

override_git_prompt_colors() {
  GIT_PROMPT_THEME_NAME="Single_line_nono031"
  GIT_PROMPT_BRANCH="${Cyan}"
  GIT_PROMPT_MASTER_BRANCH="${GIT_PROMPT_BRANCH}"
  GIT_PROMPT_UNTRACKED=" ${Cyan}…${ResetColor}"
  GIT_PROMPT_CHANGED="${Yellow}✚ "
  GIT_PROMPT_STAGED="${Magenta}●"

  GIT_PROMPT_START_USER="${BoldRed}\u@\h:${BoldBlue}\w${ResetColor}"
  GIT_PROMPT_START_ROOT="${BoldGreen}\u@\h:${BoldBlue}\w${ResetColor}"

  GIT_PROMPT_END_USER="${ResetColor}> "
  GIT_PROMPT_END_ROOT=" # ${ResetColor}"
}

reload_git_prompt_colors "Single_line_nono031"
```

Добавляем в автозапуск загрузку темы:

```linux
echo "" >> ~/.bashrc
echo "GIT_PROMPT_THEME=Custom_Single_Line_Dark" >> ~/.bashrc
```

В итоге получаем такой вот prompt:

```linux
modemfux@WSL-22.04:~/REPO/net_operations [main|✔]>
