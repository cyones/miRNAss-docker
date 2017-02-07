args <- commandArgs(trailingOnly = TRUE)

package_name = args[1]
version = args[2]

base_url = 'http://cran.us.r-project.org/src/contrib/'
if (length(args) > 2) {
  base_url = args[3]
}

archive_base_url = paste(base_url, 'Archive/', sep="")
package_url = paste(base_url, package_name, '_', version, '.tar.gz', sep="")

tryCatch(
  download.file(package_url, 'package'),
  warning = function(e) {
    package_url = paste(archive_base_url, package_name, '/', package_name, '_', version, '.tar.gz', sep="")
    download.file(package_url, 'package')
  }, finally = {
    install.packages('package', repos=NULL, type="source")
    file.remove('package')
  })

