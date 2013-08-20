activecell notes:
=================

We have adapted the ActiveWarehouse-ETL gem to our needs. At the time, the project was getting very little attention and update, and we needed to move fast, so the decision (right or wrong) was made to plow ahead without focusing on getting our enhancements back into the master gem.

If it makes sense in the future to rebase our enhancements, merge their current progress, and contribute back, I am **VERY** enthusiastic about that, but we are under incredible time/budget constraints in the near term.

getting started: terminology
----------------------------

* ETL: Extract, Transform, and Load, which is the process of moving data from one place to another with an changes to the data (transformations) that may be required. http://en.wikipedia.org/wiki/Extract,_transform,_load
* Kimball Method: A best practice pattern for data warehousing and ETL employed by the ActiveWarehouse-ETL toolkit and employed (with some modifications) to activecell
* Job: An ETL "job" is a small and contained task such as loading a table. It may or may not correspond to a "job" in a queuing system such as delayedjob or resque. In our context, jobs are defined by control files (*.ctl) in the core application's ETL config. These control files are parsed as ruby but follow a DSL that is specific to profitably-etl
* Batch: An ETL "batch" is just a collection of jobs that represent a standard pathway or workflow, such as a full data refresh or an incremental refresh. Batches may be enqueued as jobs in a queuing system such as delayedjob or resque, so don't that let terminology confuse you. In our context, batches are defined by batch files (*.ebf) in the core application's ETL config. The control files are parsed as ruby but follow a DSL that is specific to profitably-etl

getting started: typical process/flow
-------------------------------------

* in our core application (activecell), it is the Company class that owns ETL processes
* therefore, in our core application a company will have an instance method to process an etl batch, with a "type" specifying which batch control file to run
* because the etl processes are long-running, etl processes should always be enqueued and run by job workers (resque or delayedjob) in production
* when the batch is picked up for execution by profitably-etl, it is run by the "engine" a la `ETL::Engine.process()`
* at the outset, the engine parses the control files recursively using batch.rb and control.rb and their supporting files
* there are various types of source and destination systems/formats, each a subclass of Source or Destination
* once parsed successful, the engine processes the batch/controls sequentially, pulling data from the source and getting ready to insert into the destination
* along the data "pipeline" there are many possible transformations, pre-processors, post-processors, etc. some of these are part of the standard profitably-etl tool, and custom processors are defined in core application
* data is processed on a row-by-row basis and then buffered in the destination object until flushed into the destination

notes about the profitably repo
-------------------------------

in the previous repo (profitably/profitably) we followed the convention of:

* extracting from QBD directly into mongo, using mongo as a staging destination for the extracted data
* extracting from mongo, transforming row by row
* inserting into postgres using ActiveRecord
  
in activecell, we use mongo for our primary storage, so we will want a similar process:

* extract from QBD directly into mongo, using mongo as a staging destination for the extracted data
* extract from mongo, transforming row by row
* inserting into mongo using a modified version of the ActiveRecord destination (ideally) or a new Mongo destination

Helpful dev tricks:
===================
    
```ruby

# turn on console messages
ETL::Engine::realtime_activity = true
# locate a valid intuit company (ids vary--find a method locally)
ic = Company.find('5010008bfd1108e08d000003').intuit_company
# run the full etl batch to hunt for errors
ic.process_etl_batch(:full)
# run a specific job that's causing problems
# note: ETL:Engine stores the current batch, so running a job will leverage data pulled by the most recent batch!
control = (Rails.root + 'config/etl/qbd/jobs/load_qbd_bills.ctl').to_s
ETL::Engine.process(control)

```
    
    


ActiveWarehouse-ETL
===================

ActiveWarehouse-ETL is a Ruby Extract-Transform-Load (ETL) tool.

This tool is both usable and used in production under its current form - but be aware the project is under reorganization: a new team is shaping up and we're working mostly on making it easier for people to contribute first. Up-to-date documentation will only come later.

Usage
-----

The documentation is sparse and not everything is up to date, too, but here are useful bits to get you started:

* read the "Introduction":https://github.com/activewarehouse/activewarehouse-etl/wiki/Documentation
* later on, refer to the "RDoc":http://rdoc.info/github/activewarehouse/activewarehouse-etl/master/frames (be sure to check out Processor and Transform)
* read the "source":https://github.com/activewarehouse/activewarehouse-etl/tree/master/lib/etl

If you're lost, please ask questions on the "Google Group":http://groups.google.com/group/activewarehouse-discuss and we'll take care of it.

One thing to keep in mind is that ActiveWarehouse-ETL is highly hackable: you can pretty much create all you need with extra ruby code, even if it's not currently supported.

Compatibility
-------------

Current code should work with any combination of Rails 2, Rails 3, Ruby 1.8.7, Ruby 1.9.2, MySQL and Postgresql. If you meet any issue, drop a line on the "Google Group":http://groups.google.com/group/activewarehouse-discuss and/or "create an issue on github":https://github.com/activewarehouse/activewarehouse-etl/issues.

Contributing
------------

Fork on GitHub and after you've committed tested patches, send a pull request.

If you meet any error while trying to run the tests, or any failure, please drop a line on the "Google Group":http://groups.google.com/group/activewarehouse-discuss.

h3. Pre-requisites to running the tests

* install RVM and Bundler
* install MySQL and/or Postgresql (you can use brew for that)
* create test/config/database.mysql.yml and test/config/database.postgresql.yml based on "test/config/database.example.yml":https://github.com/activewarehouse/activewarehouse-etl/blob/master/test/config/database.example.yml
* create databases 'etl_unittest' and 'etl_unittest_execution' in each database, with access to the user given in the yml files

If you don't install both MySQL and Postgresql, edit "test/config/common.rb":https://github.com/activewarehouse/activewarehouse-etl/blob/master/test/config/common.rb to comment out either 'mysql' or 'pg', or the test task will raise errors.

h3. Run the tests

You can run the tests on a "combination of environments":https://github.com/activewarehouse/activewarehouse-etl/blob/master/test-matrix.yml using:

<pre>
  rake test:matrix
</pre>

h2. Contributors

ActiveWarehouse-ETL is the work of many people since late 2006 - here is a list, in no particular order:

* Anthony Eden
* Chris DiMartino
* Darrell Fuhriman
* Fabien Carrion
* Jacob Maine
* James B. Byrne
* Jay Zeschin
* Jeremy Lecour
* Steve Meyfroidt
* Seth Ladd
* Thibaut Barrère
* Stephen Touset
* sasikumargn
* Andrew Kuklewicz
* Leif Gustafson
* Andrew Sodt
* Tyler Kiley
* Colman Nady
* Scott Gonyea

If your name should be on the list but isn't, please leave a comment!

h2. Features

Currently supported features:

* ETL Domain Specific Language (DSL) - Control files are specified in a Ruby-based DSL
* Multiple source types. Current supported types:
** Fixed-width and delimited text files
** XML files through SAX
** Apache combined log format
* Multiple destination types - file and database destinations
* Support for extracting from multiple sources in a single job
* Support for writing to multiple destinations in a single job
* A variety of built-in transformations are included:
** Date-to-string, string-to-date, string-to-datetime, string-to-timestamp
** Type transformation supporting strings, integers, floats and big decimals
** Trim
** SHA-1
** Decode from an external decode file
** Default replacement for empty values
** Ordinalize
** Hierarchy lookup
** Foreign key lookup
** Ruby blocks
** Any custom transformation class
* A variety of build-in row-level processors
** Check exists processor to determine if the record already exists in the destination database
** Check unique processor to determine whether a matching record was processed during this job execution
** Copy field
** Rename field
** Hierarchy exploder which takes a tree structure defined through a parent id and explodes it into a hierarchy bridge table
** Surrogate key generator including support for looking up the last surrogate key from the target table using a custom query
** Sequence generator including support for context-sensitive sequences where the context can be defined as a combination of fields from the source data
** New row-level processors can easily be defined and applied
* Pre-processing
** Truncate processor
* Post-processing
** Bulk import using native RDBMS bulk loader tools
* Virtual fields - Add a field to the destination data which doesn't exist in the source data
* Built in job and record meta data
* Support for type 1 and type 2 slowly changing dimensions
** Automated effective date and end date time stamping for type 2
** CRC checking
