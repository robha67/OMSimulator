/*
 * This file is part of OpenModelica.
 *
 * Copyright (c) 1998-CurrentYear, Open Source Modelica Consortium (OSMC),
 * c/o Linköpings universitet, Department of Computer and Information Science,
 * SE-58183 Linköping, Sweden.
 *
 * All rights reserved.
 *
 * THIS PROGRAM IS PROVIDED UNDER THE TERMS OF GPL VERSION 3 LICENSE OR
 * THIS OSMC PUBLIC LICENSE (OSMC-PL) VERSION 1.2.
 * ANY USE, REPRODUCTION OR DISTRIBUTION OF THIS PROGRAM CONSTITUTES
 * RECIPIENT'S ACCEPTANCE OF THE OSMC PUBLIC LICENSE OR THE GPL VERSION 3,
 * ACCORDING TO RECIPIENTS CHOICE.
 *
 * The OpenModelica software and the Open Source Modelica
 * Consortium (OSMC) Public License (OSMC-PL) are obtained
 * from OSMC, either from the above address,
 * from the URLs: http://www.ida.liu.se/projects/OpenModelica or
 * http://www.openmodelica.org, and in the OpenModelica distribution.
 * GNU version 3 is obtained from: http://www.gnu.org/copyleft/gpl.html.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without
 * even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE, EXCEPT AS EXPRESSLY SET FORTH
 * IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE CONDITIONS OF OSMC-PL.
 *
 * See the full OSMC Public License conditions for more details.
 *
 */

#include "OMSFileSystem.h"
#include <cstring>

#if defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
#ifdef __cplusplus
extern "C"
{
#endif
#include <windows.h>
#ifdef __cplusplus
}
#endif
#endif

#if OMC_STD_FS == 1
// We have C++17; it has temp_directory_path and canonical
filesystem::path oms_temp_directory_path(void)
{
  return filesystem::temp_directory_path();
}

filesystem::path oms_canonical(filesystem::path p)
{
  return filesystem::canonical(p);
}
#else

#include <cstdlib>

#if (BOOST_VERSION >= 104600) // no temp_directory_path in boost < 1.46
filesystem::path oms_temp_directory_path(void) {
  return filesystem::temp_directory_path();
}
filesystem::path oms_canonical(filesystem::path p) {
  return filesystem::canonical(p);
}
#else
filesystem::path oms_temp_directory_path(void)
{
#if (_WIN32)
  char* val = (char*)malloc(sizeof(char)*(MAX_PATH + 1));
  if (!val)
  {
    logError("Out of memory");
    return NULL;
  }
  GetTempPath(MAX_PATH, val);

  filesystem::path p((val!=0) ? val : "/tmp");
  if (val) free(val);
  return p;
#else
  const char* val = 0;

  (val = std::getenv("TMPDIR" )) ||
  (val = std::getenv("TMP"    )) ||
  (val = std::getenv("TEMP"   )) ||
  (val = std::getenv("TEMPDIR"));

  filesystem::path p((val!=0) ? val : "/tmp");
  return p;
#endif // win32
}

filesystem::path oms_canonical(filesystem::path p)
{
  return p;
}
#endif
#endif

// https://svn.boost.org/trac10/ticket/1976
filesystem::path naive_uncomplete(const filesystem::path& path, const filesystem::path& base)
{
  if (path.has_root_path())
  {
    if (path.root_path() != base.root_path())
      return path;
    else
      return naive_uncomplete(path.relative_path(), base.relative_path());
  }

  if (base.has_root_path())
    throw "cannot uncomplete a relative path from a rooted base";

  typedef filesystem::path::const_iterator path_iterator;
  path_iterator path_it = path.begin();
  path_iterator base_it = base.begin();
  while (path_it != path.end() && base_it != base.end())
  {
    if (*path_it != *base_it)
      break;
    ++path_it; ++base_it;
  }

  filesystem::path result;
  for (; base_it != base.end(); ++base_it)
    result /= "..";
  for (; path_it != path.end(); ++path_it)
    result /= *path_it;
  return result;
}

filesystem::path oms_unique_path(const std::string& prefix)
{
  const char lt[] = "0123456789abcdefghijklmnopqrstuvwxyz";
  int size = strlen(lt);

  std::string s = prefix + "-";
  for(int i=0; i<8; i++)
    s += std::string(1, lt[rand() % size]);

  filesystem::path p(s);
  return p;
}

void oms_copy_file(const filesystem::path& from, const filesystem::path& to)
{
#if defined(__MINGW32__) || defined(__MINGW64__)
  /* The MINGW implementation succeeds for filesystem::copy_file, but does not
     copy the entire file.
   */
  if (!CopyFile(from.string().c_str(), to.string().c_str(), 0 /* overwrite existing */)) {
    throw std::runtime_error(std::string("Failed to copy file: ") + from.string() + "  to: " + to.string());
  }
#elif OMC_STD_FS == 1
  filesystem::copy_file(from, to, filesystem::copy_options::overwrite_existing);
#else
  filesystem::copy_file(from, to, filesystem::copy_option::overwrite_if_exists);
#endif
}

/*

The code above is partially based on the boost implementation for
filesystem::temp_directory_path.

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

*/
