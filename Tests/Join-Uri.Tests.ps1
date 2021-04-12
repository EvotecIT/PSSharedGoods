Describe 'Join-Uri' {
    It 'Testing Join-Uri joining two paths - 1' {
        $JoinOutput = Join-Uri 'https://evotec.xyz/' '/wp-json/wp/v2/posts'
        $JoinOutput | Should -Be 'https://evotec.xyz/wp-json/wp/v2/posts'
    }
    It 'Testing Join-Uri joining two paths - 2' {
        $JoinOutput = Join-Uri 'https://evotec.xyz/' 'wp-json/wp/v2/posts'
        $JoinOutput | Should -Be 'https://evotec.xyz/wp-json/wp/v2/posts'
    }
    It 'Testing Join-Uri joining two paths - 3' {
        $JoinOutput = Join-Uri -BaseUri 'https://evotec.xyz/' -RelativeOrAbsoluteUri '/wp-json/wp/v2/posts'
        $JoinOutput | Should -Be 'https://evotec.xyz/wp-json/wp/v2/posts'
    }
    It 'Testing Join-Uri joining two paths - 4' {
        $JoinOutput = Join-Uri -BaseUri 'https://evotec.xyz/wp-json/wp/v2/' -RelativeOrAbsoluteUri '/posts'
        $JoinOutput | Should -Be 'https://evotec.xyz/wp-json/wp/v2/posts'
    }
}