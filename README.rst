Boost Header-only Distribution
------------------------------

"Boost, but only the header files."

This repo is meant to provide a lightweight, minimal Boost distribution to
satisfy SciPy's limited set of Boost dependencies.  No binaries are features
relying on compiled libraries are available through this header-only
package.

Structure
---------

::

    project-root
    ├── boost/ : Contents of Boost includes directory (generated)
    ├── Boost_README_[version].md : Boost README file (generated)
    ├── LICENSE_1_0.txt : Boost license (generated)
    ├── make_headers.sh : script to create generated files
    └── README.rst : this README file

Updating
--------

To regenerate the header files or update to a new version of boost, the
`make_headers.sh` script can be modified and run on a Linux or MacOS machine
that has access to the internet.  It will automatically populate the `boost/`
directory with the generated header files from a minimal build.  It can run
very simply as follows:

.. code-block:: bash

    source make_headers.sh

To update the version of Boost, modify the `BOOST_MAJOR`, `BOOST_MINOR`,
and `BOOST_PATCH` variables at the top of `make_headers.sh`
