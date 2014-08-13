#   Copyright 2014 Brainsware
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

Puppet::Type.type(:trafficserver_plugin).provide(
  :parsed,
  :parent         => Puppet::Provider::ParsedFile,
  :default_target => '/etc/trafficserver/plugin.config',
  :filetype       => :flat,
) do

  text_line :comment, :match => /^\s*#/
  text_line :blank,   :match => /^\s*/

  text_line :parsed,
    :fields   => %w{plugin arguments comment},
    :optional => %w{options comments},
    :match    => %r{
      ^                # i don't wanna look up if ATS parser can start with spaces, so start without
      ([\S]+)          # a word (collect into a group: plugin)
      \s*              # any number of spaces
      ([\S]+)*         # optional: zero or more words, separated by spaces. (collect as: arguments)
      (?:\s*\#\s*(.*)) # optional: comment (collect as: comment)
      $
    }x
end
