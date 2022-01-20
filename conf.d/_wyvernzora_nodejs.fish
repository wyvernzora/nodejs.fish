
# Set up custom npm prefix
set -x NPM_PREFIX $HOME/.npm

# Add npm global modules to PATH
fish_add_path $NPM_PREFIX/bin
set -ax MANPATH $NPM_PREFIX/share/man

# Set NODE_PATH to be able to require globally installed modules
set -ax NODE_PATH $NPM_PREFIX/lib/node_modules

# If in interactive shell, this is probably a development environment
if status --is-interactive
    set -x NODE_ENV development
end

# My npm shortcuts
abbr --add ni npm install
abbr --add nr npm run
abbr --add nrb npm run build
abbr --add nrc npm run clean
abbr --add nrt npm run test

function _nodejs_install --on-event _wyvernzora_nodejs_install
    if not test -f $HOME/.npmrc
        echo '.npmrc is absent, creating one'
        echo "prefix=$NPM_PREFIX" >> $HOME/.npmrc
        echo "cache=$NPM_PREFIX/cache" >> $HOME/.npmrc
    else
        sed -ie "s|^prefix=.*|prefix=$NPM_PREFIX|" $HOME/.npmrc
        sed -ie "s|^cache=.*|cache=$NPM_PREFIX/cache|" $HOME/.npmrc
    end
end

function _nodejs_update --on-event _wyvernzora_nodejs_update
    _nodejs_install
end

function _nodejs_uninstall --on-event _wyvernzora_nodejs_uninstall
    rm $HOME/.npmrc
end
