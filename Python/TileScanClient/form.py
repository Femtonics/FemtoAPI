# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'form.ui'
##
## Created by: Qt User Interface Compiler version 5.14.1
##
## WARNING! All changes made in this file will be lost when recompiling UI file!
################################################################################

from PySide2.QtCore import (QCoreApplication, QMetaObject, QObject, QPoint,
    QRect, QSize, QUrl, Qt)
from PySide2.QtGui import (QBrush, QColor, QConicalGradient, QCursor, QFont,
    QFontDatabase, QIcon, QLinearGradient, QPalette, QPainter, QPixmap,
    QRadialGradient)
from PySide2.QtWidgets import *


class Ui_TileScanClient(object):
    def setupUi(self, TileScanClient):
        if TileScanClient.objectName():
            TileScanClient.setObjectName(u"TileScanClient")
        TileScanClient.resize(515, 296)
        self.formLayout_2 = QFormLayout(TileScanClient)
        self.formLayout_2.setObjectName(u"formLayout_2")
        self.formLayout = QFormLayout()
        self.formLayout.setObjectName(u"formLayout")
        self.lblScanner = QLabel(TileScanClient)
        self.lblScanner.setObjectName(u"lblScanner")

        self.formLayout.setWidget(1, QFormLayout.LabelRole, self.lblScanner)

        self.lblYDim = QLabel(TileScanClient)
        self.lblYDim.setObjectName(u"lblYDim")

        self.formLayout.setWidget(4, QFormLayout.LabelRole, self.lblYDim)

        self.lblXDim = QLabel(TileScanClient)
        self.lblXDim.setObjectName(u"lblXDim")

        self.formLayout.setWidget(3, QFormLayout.LabelRole, self.lblXDim)

        self.lblMode = QLabel(TileScanClient)
        self.lblMode.setObjectName(u"lblMode")

        self.formLayout.setWidget(2, QFormLayout.LabelRole, self.lblMode)

        self.cmbScanner = QComboBox(TileScanClient)
        self.cmbScanner.addItem("")
        self.cmbScanner.addItem("")
        self.cmbScanner.setObjectName(u"cmbScanner")

        self.formLayout.setWidget(1, QFormLayout.FieldRole, self.cmbScanner)

        self.cmbMode = QComboBox(TileScanClient)
        self.cmbMode.addItem("")
        self.cmbMode.addItem("")
        self.cmbMode.addItem("")
        self.cmbMode.setObjectName(u"cmbMode")

        self.formLayout.setWidget(2, QFormLayout.FieldRole, self.cmbMode)

        self.spnDimX = QSpinBox(TileScanClient)
        self.spnDimX.setObjectName(u"spnDimX")
        self.spnDimX.setMinimum(1)
        self.spnDimX.setMaximum(9999)
        self.spnDimX.setValue(3)

        self.formLayout.setWidget(3, QFormLayout.FieldRole, self.spnDimX)

        self.spnDimY = QSpinBox(TileScanClient)
        self.spnDimY.setObjectName(u"spnDimY")
        self.spnDimY.setMinimum(1)
        self.spnDimY.setMaximum(9999)
        self.spnDimY.setValue(3)

        self.formLayout.setWidget(4, QFormLayout.FieldRole, self.spnDimY)

        self.lblResX = QLabel(TileScanClient)
        self.lblResX.setObjectName(u"lblResX")

        self.formLayout.setWidget(5, QFormLayout.LabelRole, self.lblResX)

        self.spnResolution = QSpinBox(TileScanClient)
        self.spnResolution.setObjectName(u"spnResolution")
        self.spnResolution.setMinimum(64)
        self.spnResolution.setMaximum(9999)
        self.spnResolution.setValue(512)

        self.formLayout.setWidget(5, QFormLayout.FieldRole, self.spnResolution)

        self.lblViewPortX = QLabel(TileScanClient)
        self.lblViewPortX.setObjectName(u"lblViewPortX")

        self.formLayout.setWidget(6, QFormLayout.LabelRole, self.lblViewPortX)

        self.lblViewportY = QLabel(TileScanClient)
        self.lblViewportY.setObjectName(u"lblViewportY")

        self.formLayout.setWidget(7, QFormLayout.LabelRole, self.lblViewportY)

        self.spnViewportX = QSpinBox(TileScanClient)
        self.spnViewportX.setObjectName(u"spnViewportX")
        self.spnViewportX.setValue(1)

        self.formLayout.setWidget(6, QFormLayout.FieldRole, self.spnViewportX)

        self.spnViewportY = QSpinBox(TileScanClient)
        self.spnViewportY.setObjectName(u"spnViewportY")
        self.spnViewportY.setValue(1)

        self.formLayout.setWidget(7, QFormLayout.FieldRole, self.spnViewportY)

        self.lblOverlap = QLabel(TileScanClient)
        self.lblOverlap.setObjectName(u"lblOverlap")

        self.formLayout.setWidget(8, QFormLayout.LabelRole, self.lblOverlap)

        self.spnOverlap = QSpinBox(TileScanClient)
        self.spnOverlap.setObjectName(u"spnOverlap")
        self.spnOverlap.setMaximum(9999)
        self.spnOverlap.setValue(10)

        self.formLayout.setWidget(8, QFormLayout.FieldRole, self.spnOverlap)

        self.btnStart = QPushButton(TileScanClient)
        self.btnStart.setObjectName(u"btnStart")

        self.formLayout.setWidget(9, QFormLayout.LabelRole, self.btnStart)


        self.formLayout_2.setLayout(1, QFormLayout.LabelRole, self.formLayout)

        self.lblgraphic = QLabel(TileScanClient)
        self.lblgraphic.setObjectName(u"lblgraphic")
        self.lblgraphic.setPixmap(QPixmap(u"../../../Users/hock.zoltan/Pictures/YWu/tilescan.png"))

        self.formLayout_2.setWidget(1, QFormLayout.FieldRole, self.lblgraphic)


        self.retranslateUi(TileScanClient)

        QMetaObject.connectSlotsByName(TileScanClient)
    # setupUi

    def retranslateUi(self, TileScanClient):
        TileScanClient.setWindowTitle(QCoreApplication.translate("TileScanClient", u"Tile Scan Client for MESc", None))
        self.lblScanner.setText(QCoreApplication.translate("TileScanClient", u"Scanner", None))
        self.lblYDim.setText(QCoreApplication.translate("TileScanClient", u"yDimesion", None))
        self.lblXDim.setText(QCoreApplication.translate("TileScanClient", u"xDimension", None))
        self.lblMode.setText(QCoreApplication.translate("TileScanClient", u"Mode", None))
        self.cmbScanner.setItemText(0, QCoreApplication.translate("TileScanClient", u"Resonant", None))
        self.cmbScanner.setItemText(1, QCoreApplication.translate("TileScanClient", u"Galvo", None))

        self.cmbMode.setItemText(0, QCoreApplication.translate("TileScanClient", u"Time Series", None))
        self.cmbMode.setItemText(1, QCoreApplication.translate("TileScanClient", u"Z-Stack", None))
        self.cmbMode.setItemText(2, QCoreApplication.translate("TileScanClient", u"Volume Scan", None))

        self.lblResX.setText(QCoreApplication.translate("TileScanClient", u"Resolution X", None))
        self.lblViewPortX.setText(QCoreApplication.translate("TileScanClient", u"Viewport X", None))
        self.lblViewportY.setText(QCoreApplication.translate("TileScanClient", u"Viewport Y", None))
        self.lblOverlap.setText(QCoreApplication.translate("TileScanClient", u"Ovellap", None))
        self.spnOverlap.setSuffix("")
        self.btnStart.setText(QCoreApplication.translate("TileScanClient", u"Start", None))
        self.lblgraphic.setText("")
    # retranslateUi

