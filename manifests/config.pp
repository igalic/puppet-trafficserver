#   Copyright 2016 Brainsware
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

# This class manages some basics of traffic server's configuration
# For more complex things settings, please use trafficserver_record directly!
# or any other (defined) types.
class trafficserver::config {

  # basic (concat) setup for trafficserver storage and remap
  include ::trafficserver::config::storage
  include ::trafficserver::config::remap
  # configure (most basic) records parameters, exposed through init.pp
  include ::trafficserver::config::records

  # trafficserver_record operates on the beating heart, but these files here
  # need a reload:
  file { [
    "${::trafficserver::sysconfdir}/plugin.config",
    "${::trafficserver::sysconfdir}/ssl_multicert.config",
  ]:
    ensure => file,
    owner  => $trafficserver::user,
    group  => $trafficserver::group,
    notify => Class[trafficserver::service],
  }

  Class[trafficserver::config::storage] -> Class[trafficserver::config]
  Class[trafficserver::config::remap]   -> Class[trafficserver::config]
  Class[trafficserver::config::records] -> Class[trafficserver::config]
}
