Describe 'Join-Uri' {
    It 'Testing Join-UriQuery joining two paths and multiple queries' {
        $JoinOutput = Join-UriQuery -BaseUri 'https://evotec.xyz/' -RelativeOrAbsoluteUri '/wp-json/wp/v2/posts' -QueryParameter ([ordered]@{
                page     = 1
                per_page = 20
                search   = 'SearchString'
            })
        $JoinOutput | Should -Be 'https://evotec.xyz/wp-json/wp/v2/posts?page=1&per_page=20&search=SearchString'
    }
}