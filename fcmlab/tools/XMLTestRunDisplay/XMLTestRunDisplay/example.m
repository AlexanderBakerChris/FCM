%add source code to path; also requires svn on system path to collect
%revision information
addpath('src');
addpath('src_test'); %tests
addpath('C:\Users\jkarr\Documents\WholeCell-simulation\lib\matlab_xunit_3.0.1\xunit') %xunit 3.0.1

%import classses, functions
import edu.stanford.covert.test.runtests;
import edu.stanford.covert.test.XMLTestRunDisplay;

%run and log tests
name = 'Example test log.';
description = 'Example JUnit-style XML test log.';
outFileName = 'example.log.xml';
tests = 'edu.stanford.covert.util';

monitor = XMLTestRunDisplay(name, description, outFileName);
runtests(monitor, tests)