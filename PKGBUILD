# Maintainer: ManInDark
pkgname=pam_daily_word
pkgver=1.0.7
pkgrel=1
pkgdesc="a daily word guessing PAM Module"
arch=('x86_64')
url="https://github.com/ManInDark/pam_daily_word"
license=()
depends=()
makedepends=('git' 'base-devel')
source=("git+https://github.com/ManInDark/$pkgname.git#tag=$pkgver")
md5sums=('SKIP')

pkgver() {
    cd "$srcdir/$pkgname"
    git describe --tags --long | sed 's/-/./g'
}

build() {
    cd "$srcdir/$pkgname"
    make build
}

package() {
    cd "$srcdir/$pkgname"

    install -D list "$pkgdir/etc/daily-word/list"
    install -D bin/provider.so "$pkgdir/usr/lib/security/pam_daily_word.so"
}
