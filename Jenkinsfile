#!groovy

/* Set the properties this job has.
   I think there's a bug where the very first run lacks these... */
properties([
  /* Set our config to take a parameter when a build is triggered.
     We should always have defaults, I don't know what happens when
     it's triggered by a commit without a default... */
  [ $class: 'ParametersDefinitionProperty',
    parameterDefinitions: [
      [ $class: 'StringParameterDefinition',
        name: 'SILVER_BASE',
        defaultValue: '/export/scratch/melt-jenkins/custom-silver/',
        description: 'Silver installation path to use. Currently assumes only one build machine. Otherwise a path is not sufficient, we need to copy artifacts or something else.'
      ]
    ]
  ],
  /* If we don't set this, everything is preserved forever.
     We don't bother discarding build logs (because they're small),
     but if this job keeps artifacts, we ask them to only stick around
     for awhile. */
  [ $class: 'BuildDiscarderProperty',
    strategy:
      [ $class: 'LogRotator',
        artifactDaysToKeepStr: '120',
        artifactNumToKeepStr: '20'
      ]
  ]
])

/* If the above syntax confuses you, be sure you've skimmed through
   https://github.com/jenkinsci/pipeline-plugin/blob/master/TUTORIAL.md

   In particular, Jenkins has this thing that turns a map with a '$class' property
   into an actual object of that type, with the remainder of the map being its
   parameters. */


/* a node allocates an executor to actually do work */
node {
  try {
//    notifyBuild('STARTED')

    /* stages are pretty much just labels about what's going on */
    stage ("Build") {
      checkout scm

      /* env.PATH is the master's path, not the executor's */
      withEnv(["PATH=${SILVER_BASE}/support/bin/:${env.PATH}"]) {
        sh "./build --warn-all"
      }
    }

    stage ("Extensions") {
      build job: '/melt-umn/edu.umn.cs.melt.exts.ableC.sqlite/master', parameters:
        [[$class: 'StringParameterValue', name: 'SILVER_BASE', value: SILVER_BASE],
         [$class: 'StringParameterValue', name: 'ABLEC_BASE', value: WORKSPACE]]
//    build job: '/melt-umn/ableC-condition-tables/master', parameters:
//      [[$class: 'StringParameterValue', name: 'SILVER_BASE', value: SILVER_BASE],
//       [$class: 'StringParameterValue', name: 'ABLEC_BASE', value: WORKSPACE]]
    }

    /* TODO: use nailgun!
       sh ". ${SILVER_BASE}/support/nailgun/sv-nailgun"
       sh "sv-serve ableC.jar"
       sh "python testing/supertest.py ${SILVER_BASE}/support/nailgun/sv-call testing/tests/*"
    */
    stage ("Test") {
      dir("testing/expected-results") {
        sh "./runTests"
      }
    }
	} catch (e) {
		currentBuild.result = 'FAILURE'
		throw e
	} finally {
		if (currentBuild.result == 'FAILURE') {
			notifyBuild(currentBuild.result)
		}
	}
}

/* Slack / email notification
 * notifyBuild() author: fahl-design
 * https://bitbucket.org/snippets/fahl-design/koxKe */
def notifyBuild(String buildStatus = 'STARTED') {
  // build status of null means successful
  buildStatus =  buildStatus ?: 'SUCCESSFUL'

  // Default values
  def colorName = 'RED'
  def colorCode = '#FF0000'
  def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
  def summary = "${subject} (${env.BUILD_URL})"
  def details = """<p>STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
    <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>"""

  // Override default values based on build status
  if (buildStatus == 'STARTED') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'SUCCESSFUL') {
    color = 'GREEN'
    colorCode = '#00FF00'
  } else {
    color = 'RED'
    colorCode = '#FF0000'
  }

  // Send notifications
  slackSend (color: colorCode, message: summary)

  emailext(
      subject: subject,
      body: details,
			to: 'evw@umn.edu',
      recipientProviders: [[$class: 'CulpritsRecipientProvider']]
    )
}

