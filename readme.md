==Open-Org==

--Overview--

This project is an attempt at making a set of tools to run any organization
(either non-profit or for-profit) where the data can be viewable on a
continuim from public to private. The basic idea is to make all information
about the organization open as
the default with privacy as necessary. It aims to start out as a very
simple task manager with users/groups, roles and tasks and a method for
defining groups of tasks in a text format that can be forked and shared
using git. That way, organizational structures can be duplicated by others
in different places.

It will use a plugin architecture to allow different types of organizations
to have their types of tasks available for use. The plugins will bring in
a domain vocabulary that the task definitions can reference for their 
specific organizational areas.

Also built-in will be an accounting system. This will necessarily start
out simple with complexity added as needed. 

Lastly, there will be tools to audit both money flows and consequently
power changes within an organization. It will provide organizational charts
and who has control over what aspects of the organization. The point of these auditing tools is to promote trust and promote the idea of a volunteer
auditor. Open organizations can provide more trust than any closed
organization and auditors can assist in that so that fraud is found out as
soon as possible and inefficiencies can be continually be rung out of the
system.

--Design Decisions--

1. General Principles

The system is written in Ruby on Rails because that is what I like to 
program in and what I know best. The plugin system used is the Ruby on 
Rails engines architecture. The runtime environment is JRuby because it
is the best runtime for Ruby at this time.

2. Task Graph Definitions

An organization can have many task graph definitions and they can be 
built up on each other to (hopefully) model all an organizations activities.
Right now, task definitions can only be created through a Domain Specific
Language (DSL) to describe tasks and how they are related to each other.
When a new task graph definition is saved, task graph definitions that are
superceeded are marked as not current and can no longer be used for new
tasks. Any tasks in process from an old task graph definition can proceed
to completion, but any new task graph's that are started will use the
new definition.







