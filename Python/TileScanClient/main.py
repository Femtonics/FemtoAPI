# Copyright ©2021. Femtonics Ltd. (Femtonics). All Rights Reserved. 
# Permission to use, copy, modify this software and its documentation for educational,
# research, and not-for-profit purposes, without fee and without a signed licensing agreement, is 
# hereby granted, provided that the above copyright notice, this paragraph and the following two 
# paragraphs appear in all copies, modifications, and distributions. Contact info@femtonics.eu
# for commercial licensing opportunities.
# 
# IN NO EVENT SHALL FEMTONICS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF 
# THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF FEMTONICS HAS BEEN 
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# FEMTONICS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
# PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED 
# HEREUNDER IS PROVIDED "AS IS". FEMTONICS HAS NO OBLIGATION TO PROVIDE 
# MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

# This Python file uses the following encoding: utf-8

"""
In this application you can set the tile scan parameters, and initiate the measurement.
"""

import sys
import os
import time
import logging
from pathlib import Path
# from PySide2 import QtGui, QtWidgets
from PySide2.QtWidgets import QApplication, QWidget, QFileDialog, QPushButton
from PySide2.QtCore import QFile, Qt, QRunnable
from PySide2.QtCore import QSettings, QSize
from PySide2 import QtCore
from PySide2.QtUiTools import QUiLoader
from PySide2.QtGui import QPalette, QColor
from PySide2.QtGui import QPixmap
import TileScanPy
import resources
import logFormatter


class TileScanClient(QWidget):
    def __init__(self):
        super(TileScanClient, self).__init__()
        self.logger_init()
        windowTitle = "Tile Scan Extension for MESc"
        self.setWindowTitle(windowTitle)
        self.settings = QSettings("Femtonics", "TileScanClient")
        self.load_ui()
        self.threadpool = QtCore.QThreadPool()
#        self.readSettings()
        self.tileScanPy = TileScanPy.TileScanPy()
        #self.ui.closeEvent.connect(self.quit_app)
        #try:
        #    print('window size')
        #    self.ui.resize(self.settings.value('window size'))
        #    self.ui.move(self.settings.value('window position'))
        #except:
        #    pass
    def on_cmbMode_changed(self, value):
        pixmap = QPixmap(':/images/' + str(value))
        self.ui.lblgraphic.setPixmap(pixmap)
        self.ui.lblgraphic.update()

    def quit_app(self):
            # some actions to perform before actually quitting:
            self.writeSettings()
            app.exit()

    def logger_init(self):
        """
        Initializing logger
        """
        ts = time.localtime()
        timestamp = time.strftime("%Y%m%d%H%M%S", ts)
        fname = "C:\\Users\\Public\\Femtonics\\MEScLog\\TileScan.log"
        logging.basicConfig(filename=Path(fname), level=logging.DEBUG)
        logger = logging.getLogger()
        formatter = logFormatter.MyFormatter(fmt='<%(asctime)s> [%(levelname)s] <%(module)s> %(message)s',datefmt='%Y-%m-%d,%H:%M:%S.%f')
        console = logger.handlers[0]
        console.setFormatter(formatter)

    def readSettings(self):
        self.settings.beginGroup("MainWindow")
        self.ui.restoreGeometry(self.settings.value( "geometry", self.saveGeometry()))
        #self.ui.restoreState(self.settings.value( "saveState", self.saveState()))
        self.ui.move(self.settings.value( "pos", self.pos()))
        self.ui.resize(self.settings.value( "size", self.size()))
        if self.settings.value( "maximized", self.ui.isMaximized()) :
           self.ui.showMaximized()
        self.settings.endGroup()

    def writeSettings(self):
        scanner = self.ui.cmbScanner.currentText()
        mode = self.ui.cmbMode.currentIndex()
        viewpX = self.ui.spnViewportX.value()
        viewpY = self.ui.spnViewportY.value()
        resX = self.ui.spnResolution.value()
        resY = self.ui.spnResolution.value()
        dimX = self.ui.spnDimX.value()
        dimY = self.ui.spnDimY.value()
        ovrlap = self.ui.spnOverlap.value()
        outDir = self.ui.lineEditOutput.text()
        fstX = self.ui.dsbFirstX.value()
        fstY = self.ui.dsbFirstY.value()

        self.settings.beginGroup("MainWindow")
        self.settings.setValue( "geometry", self.saveGeometry())
        self.settings.setValue( "saveState", self.saveState())
        self.settings.setValue( "maximized", self.isMaximized())
        if not self.ui.isMaximized() is True:
            self.settings.setValue( "pos", self.ui.pos())
            self.settings.setValue( "size", self.ui.size())
        self.settings.endGroup()
        self.settings.beginGroup("Parameters")
        self.settings.setValue("scanner", scanner)
        self.settings.setValue("viewpX", viewpX)
        self.settings.setValue("viewpY", viewpY)
        self.settings.setValue("resX", resX)
        self.settings.setValue("resY", resY)
        self.settings.setValue("dimX", dimX)
        self.settings.setValue("dimY", dimY)
        self.settings.setValue("ovrlap", ovrlap)
        self.settings.setValue("outDir". outDir)
        self.settings.setValue("fstX", fstX)
        self.settings.setValue("fstY", fstY)
        self.settings.setValue("mode", mode)
        self.settings.endGroup()

    def load_ui(self):
        loader = QUiLoader()
        path = os.path.join(os.path.dirname(__file__), "form.ui")
        ui_file = QFile(path)
        ui_file.open(QFile.ReadOnly)
        self.ui = loader.load(ui_file, self)
        ui_file.close()
        micrometer = " \u00B5m"
        self.ui.btnStart.clicked.connect(self.start_tile_scan)
        self.ui.btnAbort.clicked.connect(self.abort_tile_scan)
        self.ui.btnBrowse.clicked.connect(self.browse_output)
        self.ui.btnSlowX.clicked.connect(self.get_current_x)
        self.ui.btnSlowY.clicked.connect(self.get_current_y)
#        self.ui.spnDimX.editingFinished.connect(self.dim_x_changed)
#        self.ui.spnDimY.editingFinished.connect(self.dim_y_changed)
        self.ui.spnViewportX.setSuffix(micrometer)
        self.ui.spnViewportY.setSuffix(micrometer)
        self.ui.spnOverlap.setSuffix(micrometer)
        self.ui.dsbFirstX.setSuffix(micrometer)
        self.ui.dsbFirstY.setSuffix(micrometer)
        self.ui.cmbMode.currentIndexChanged.connect(self.on_cmbMode_changed)
        pixmap = QPixmap(':/images/2')
        self.ui.lblgraphic.setPixmap(pixmap)

    #def dim_x_changed(self):
        #self.regenerateLayout()

    #def dim_y_changed(self):
        #self.regenerateLayout()

    def regenerateLayout(self):
        for i in reversed(range(self.ui.gridLayout.count())):
            self.ui.gridLayout.itemAt(i).widget().setParent(None)

        for rows in range(self.ui.spnDimX.value(), 0, -1):
            for columns in range(0, self.ui.spnDimY.value()):
                buttonstr = str(self.ui.gridLayout.count() + 1)
                print(buttonstr +" row:" + str(rows) + " column:" +str(columns) + " " + str(rows + columns) + " " + str(self.ui.gridLayout.count() - rows - columns))
                button = QPushButton(buttonstr)
                if (rows % 2) == 0:
                    self.ui.gridLayout.addWidget(button, rows, self.ui.spnDimY.value() - columns - 1)
                else:
                    self.ui.gridLayout.addWidget(button, rows, columns)

    def start_tile_scan(self):
        self.tileScanPy.abortRun = False
        scanner = self.ui.cmbScanner.currentText()
        viewpX = self.ui.spnViewportX.value()
        viewpY = self.ui.spnViewportY.value()
        resX = self.ui.spnResolution.value()
        resY = self.ui.spnResolution.value()
        dimX = self.ui.spnDimX.value()
        dimY = self.ui.spnDimY.value()
        ovrlap = self.ui.spnOverlap.value()
        outDir = self.ui.lineEditOutput.text()
        fstX = self.ui.dsbFirstX.value()
        fstY = self.ui.dsbFirstY.value()
        xDirection = 1
        yDirection = 1
        if 0 == self.ui.cmbMode.currentIndex() :
            xDirection = 1
            yDirection = -1
        elif 1 == self.ui.cmbMode.currentIndex() :
            xDirection = -1
            yDirection = -1
        elif 2 == self.ui.cmbMode.currentIndex() :
            xDirection = 1
            yDirection = 1
        elif 3 == self.ui.cmbMode.currentIndex() :
            xDirection = -1
            yDirection = 1
        print("Starting.. with " + scanner + " vX:" + str(viewpX) +" vY:" + str(viewpY))
        self.tileScanPy.setParameters(scanner, viewpX, viewpY,
        resX, resY, dimX, dimY, ovrlap, fstX, fstY, outDir, xDirection, yDirection)

    def abort_tile_scan(self):
        scanner = self.ui.cmbScanner.currentText()
        self.tileScanPy.abortMeasurement(scanner)
        self.tileScanPy.abortRun = True

    def browse_output(self):
        self.ui.lineEditOutput.setText( str(QFileDialog.getExistingDirectory(self, "Select Directory")))

    def get_current_x(self):
        self.ui.dsbFirstX.setValue(self.tileScanPy.getCurrentX())

    def get_current_y(self):
        self.ui.dsbFirstY.setValue(self.tileScanPy.getCurrentY())

    def closeEvent(self, event):
        print('closeEvent')
        self.settings.setValue('window size', self.ui.size())
        self.settings.setValue('window position', self.ui.pos())

    def progress_fn(self, msg):

        self.info.append(str(msg))
        return

    def run_threaded_process(self, process, on_complete):
        """Execute a function in the background with a worker"""

        worker = Worker(fn=process)
        self.threadpool.start(worker)
        worker.signals.finished.connect(on_complete)
        worker.signals.progress.connect(self.progress_fn)
        self.ui.progressbar.setRange(0,0)
        return

    def test(self, progress_callback):
        total = 500
        for i in range(0,total):
            time.sleep(.2)
            x = random.randint(1,1e4)
            progress_callback.emit(x)
            if self.stopped == True:
                return

    def run(self):
        self.stopped = False
        self.run_threaded_process(self.start_tile_scan, self.completed)

    def stop(self):
        self.stopped = True
        return

    def completed(self):
        self.ui.progressbar.setRange(0,1)
        return

#https://www.learnpyqt.com/courses/concurrent-execution/multithreading-pyqt-applications-qthreadpool/
class Worker(QtCore.QRunnable):
    """Worker thread for running background tasks."""

    def __init__(self, fn, *args, **kwargs):
        super(Worker, self).__init__()
        # Store constructor arguments (re-used for processing)
        self.fn = fn
        self.args = args
        self.kwargs = kwargs
        self.signals = WorkerSignals()
        self.kwargs['progress_callback'] = self.signals.progress

    @QtCore.Slot()
    def run(self):
        try:
            result = self.fn(
                *self.args, **self.kwargs,
            )
        except:
            traceback.print_exc()
            exctype, value = sys.exc_info()[:2]
            self.signals.error.emit((exctype, value, traceback.format_exc()))
        else:
            self.signals.result.emit(result)
        finally:
            self.signals.finished.emit()

class WorkerSignals(QtCore.QObject):
    """
    Defines the signals available from a running worker thread.
    Supported signals are:
    finished
        No data
    error
        `tuple` (exctype, value, traceback.format_exc() )
    result
        `object` data returned from processing, anything
    """
    finished = QtCore.Signal()
    error = QtCore.Signal(tuple)
    result = QtCore.Signal(object)
    progress = QtCore.Signal(int)


if __name__ == "__main__":
    app = QApplication([])
    app.setStyle("Fusion")

    dark_palette = QPalette()

    dark_palette.setColor(QPalette.Window, QColor(53, 53, 53))
    dark_palette.setColor(QPalette.WindowText, Qt.white)
    dark_palette.setColor(QPalette.Base, QColor(25, 25, 25))
    dark_palette.setColor(QPalette.AlternateBase, QColor(53, 53, 53))
    dark_palette.setColor(QPalette.ToolTipBase, Qt.white)
    dark_palette.setColor(QPalette.ToolTipText, Qt.white)
    dark_palette.setColor(QPalette.Text, Qt.white)
    dark_palette.setColor(QPalette.Button, QColor(53, 53, 53))
    dark_palette.setColor(QPalette.ButtonText, Qt.white)
    dark_palette.setColor(QPalette.BrightText, Qt.red)
    dark_palette.setColor(QPalette.Link, QColor(42, 130, 218))
    dark_palette.setColor(QPalette.Highlight, QColor(255, 128, 0))
    dark_palette.setColor(QPalette.HighlightedText, Qt.black)

    app.setPalette(dark_palette)
#    sys.stdout = codecs.getwriter('utf8')(sys.stdout)
#    sys.stderr = codecs.getwriter('utf8')(sys.stderr)
    app.setStyleSheet("QToolTip { color: #ffffff; background-color: #2a82da; border: 1px solid white; }")
    widget = TileScanClient()
    widget.show()
    sys.exit(app.exec_())
